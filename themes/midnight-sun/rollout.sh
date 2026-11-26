#!/bin/zsh
# Build and install every one of his apps that carries a plate icon. Run it after the icon files are written
# (plates.py export, hoard_apple.py, and tools/make-icon.py in grimoire) and each repo is committed.
#   rollout.sh [name ...]     names from the list at the bottom; all when none are given
# Every build ships that repo's working tree, so look at `git status` in each repo first.
# Mac apps are reopened in the background, and only if they were running. Logs and summary go to $ROLLOUT_LOG
# (default /tmp/plate-rollout). Not covered: the phone's home-screen shortcut icons (README runbook), the Mac
# icons of other people's apps (the LaunchAgent applies those) and `sudo mac/admin/apply-admin-icons.sh`.
L=${ROLLOUT_LOG:-/tmp/plate-rollout}; mkdir -p $L; SUM=$L/summary; : > $SUM
P=~/Projects
dev() { xcrun devicectl list devices 2>/dev/null | grep -E "$1.*physical" | grep -E 'available|connected' | grep -oE '[0-9A-F]{8}-[0-9A-F]{16}' | head -1 }
PHONE=$(dev iPhone); TV=$(dev 'Apple TV')
want() { (( ${#WANT} == 0 )) || (( ${WANT[(Ie)$1]} )) }
note() { print -r -- "$*" >> $SUM }

web() { # name: the repo's own deploy script
  want $1 || return; (cd $P/$1 && ops/deploy.sh > $L/web-$1.log 2>&1); note "web $1: exit $?" }

mac() { # name, App name, repo dir, build command, built .app (relative to the repo dir), install dir
  want $1 || return; local n=$1 app=$2 dir=$P/$3 cmd=$4 built=$P/$3/$5 dest=${6:-/Applications}
  (cd $dir && eval "$cmd") > $L/mac-$n.log 2>&1
  [[ -d $built ]] && grep -q "BUILD SUCCEEDED" $L/mac-$n.log || { note "mac $app: BUILD FAILED"; return }
  local was=no; pgrep -f "$app.app/Contents/MacOS/" >/dev/null && was=yes
  osascript -e "quit app \"$app\"" 2>/dev/null; sleep 2
  rsync -a --delete "$built/" "$dest/$app.app/" && touch "$dest/$app.app"
  [[ $was == yes ]] && open -g "$dest/$app.app"
  note "mac $app: installed $(date +%H:%M) (was running: $was)" }

device() { # label, device id, name, repo dir, generate command, xcodebuild args, built .app (relative to the repo dir)
  want $3 || return; local label=$1 id=$2 n=$3 dir=$P/$4 gen=$5 args=$6 built=$P/$4/$7 log=$L/$1-$3.log
  [[ -n $id ]] || { note "$label $n: no device"; return }
  (cd $dir && eval "$gen" && eval "xcodebuild $args -allowProvisioningUpdates build" 2>&1 | grep -E "error:|BUILD") > $log 2>&1
  [[ -d $built ]] && grep -q "BUILD SUCCEEDED" $log || { note "$label $n: BUILD FAILED"; return }
  for try in 1 2 3; do
    xcrun devicectl device install app --device $id $built >> $log 2>&1 && { note "$label $n: installed $(date +%H:%M)"; return }
    sleep 20   # a locked or sleeping device refuses the install
  done
  note "$label $n: built, INSTALL FAILED" }

ios() { device phone "$PHONE" "$@" }
XB='-configuration Release -destination "platform=macOS"'
IOS='-configuration Release -destination "generic/platform=iOS"'
GEN='../scripts/generate-project.sh --quiet'
WANT=("$@")

web hoard; web haunt; web cauldron

mac ledger   Ledger   ledger   'scripts/build-mac.sh Release' App/build.noindex/Build/Products/Release/Ledger.app
mac forge    Forge    forge    'scripts/build-mac.sh Release' App/build.noindex/Build/Products/Release/Forge.app
mac coinbox  Coinbox  coinbox  'scripts/build-mac.sh Release' App/build.noindex/Build/Products/Release/Coinbox.app
mac practice Practice practice 'apple/scripts/build-mac.sh Release' apple/App/build.noindex/Build/Products/Release/Practice.app
mac grimoire Grimoire grimoire 'scripts/build-mac.sh Release' App/build.noindex/Build/Products/Release/Grimoire.app ~/Applications
mac cauldron Cauldron cauldron/apple "./generate.sh --quiet && xcodebuild -project Cauldron.xcodeproj -scheme CauldronMac $XB -derivedDataPath build-mac.noindex build" build-mac.noindex/Build/Products/Release/Cauldron.app
mac sprig    Sprig    sprig/ios "scripts/generate-project.sh && xcodebuild -project Sprig.xcodeproj -scheme SprigMac $XB -derivedDataPath build/mac build" build/mac/Build/Products/Release/Sprig.app
mac almanac  Almanac  almanac  "xcodegen generate --quiet && xcodebuild -project Almanac.xcodeproj -scheme Almanac $XB -allowProvisioningUpdates -derivedDataPath build build" build/Build/Products/Release/Almanac.app
mac stacks   Stacks   stacks/app './generate-project.sh --quiet && xcodebuild -project Stacks.xcodeproj -scheme Stacks -configuration Release -destination "platform=macOS,variant=Mac Catalyst" -allowProvisioningUpdates -derivedDataPath build.noindex build' build.noindex/Build/Products/Release-maccatalyst/Stacks.app
selfinstall() { # name, App name, repo dir, script: these repos' build scripts install into /Applications themselves
  want $1 || return; local w=no; pgrep -x $2 >/dev/null && w=yes
  (cd $P/$3 && eval "$4" > $L/mac-$1.log 2>&1); [[ $w == yes ]] && { sleep 1; open -g /Applications/$2.app }
  note "mac $2: script done $(date +%H:%M) (was running: $w)" }
selfinstall tend  Tend  tend  'scripts/build-mac.sh'
selfinstall haunt Haunt haunt 'apple/scripts/build-mac.sh'
if want hoard; then   # Hoard's Mac app has its own build-and-install script
  w=no; pgrep -x Hoard >/dev/null && w=yes; osascript -e 'quit app "Hoard"' 2>/dev/null
  (cd $P/hoard-apple/HoardMac && ./build.sh --install > $L/mac-hoard.log 2>&1); [[ $w == yes ]] && open -g /Applications/Hoard.app
  note "mac Hoard: build.sh done (was running: $w)"
fi

ios ledger   ledger/App         "$GEN" "-project Ledger.xcodeproj -scheme LedgeriOS $IOS -derivedDataPath ../build-device.noindex" ../build-device.noindex/Build/Products/Release-iphoneos/Ledger.app
ios forge    forge/App          "$GEN" "-project Forge.xcodeproj -scheme ForgeiOS $IOS -derivedDataPath ../build-device.noindex" ../build-device.noindex/Build/Products/Release-iphoneos/Forge.app
ios coinbox  coinbox/App        "$GEN" "-project Coinbox.xcodeproj -scheme CoinboxiOS $IOS -derivedDataPath ../build-device.noindex" ../build-device.noindex/Build/Products/Release-iphoneos/Coinbox.app
ios practice practice/apple/App "$GEN" "-project Practice.xcodeproj -scheme PracticeiOS $IOS -derivedDataPath build-device.noindex" build-device.noindex/Build/Products/Release-iphoneos/Practice.app
ios haunt    haunt/apple/App    "$GEN" "-project Haunt.xcodeproj -scheme HauntiOS $IOS -derivedDataPath build-device.noindex" build-device.noindex/Build/Products/Release-iphoneos/Haunt.app
ios grimoire grimoire/App       "$GEN" "-project Grimoire.xcodeproj -scheme GrimoireiOS $IOS -derivedDataPath build-device.noindex" build-device.noindex/Build/Products/Release-iphoneos/Grimoire.app
ios cauldron cauldron/apple     './generate.sh --quiet' "-project Cauldron.xcodeproj -scheme Cauldron $IOS -derivedDataPath build-device.noindex" build-device.noindex/Build/Products/Release-iphoneos/Cauldron.app
ios sprig    sprig/ios          'scripts/generate-project.sh' "-project Sprig.xcodeproj -scheme Sprig $IOS -derivedDataPath build/device" build/device/Build/Products/Release-iphoneos/Sprig.app
ios tarot    tarot/app          'xcodegen generate --quiet' "-project Tarot.xcodeproj -scheme Tarot $IOS -derivedDataPath build-device.noindex" build-device.noindex/Build/Products/Release-iphoneos/Tarot.app
ios omen     omen               'xcodegen generate --quiet' "-project Omen.xcodeproj -scheme Omen $IOS -derivedDataPath build" build/Build/Products/Release-iphoneos/Omen.app
ios stacks   stacks/app         './generate-project.sh --quiet' "-project Stacks.xcodeproj -scheme Stacks $IOS -derivedDataPath build.noindex" build.noindex/Build/Products/Release-iphoneos/Stacks.app
ios almanac  almanac            'xcodegen generate --quiet' "-project Almanac.xcodeproj -scheme Almanac $IOS -derivedDataPath build" build/Build/Products/Release-iphoneos/Almanac.app
# Hoard on iPhone and Apple TV is the Swiftfin fork: Debug, and its Swift macros need the two skip flags on the command line
HO='-skipMacroValidation -skipPackagePluginValidation -derivedDataPath build.noindex'
ios hoard hoard-apple true "-project Swiftfin.xcodeproj -scheme Swiftfin -configuration Debug -destination generic/platform=iOS $HO" build.noindex/Build/Products/Debug-iphoneos/Swiftfin.app
device tv "$TV" hoard hoard-apple true "-project Swiftfin.xcodeproj -scheme 'Swiftfin tvOS' -configuration Debug -destination generic/platform=tvOS $HO" build.noindex/Build/Products/Debug-appletvos/Swiftfin.app

cat $SUM
