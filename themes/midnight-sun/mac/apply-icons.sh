#!/bin/zsh
# Give apps their Midnight Sun icon and put it back after an app update wipes it.
# Run by the LaunchAgent com.nicholai.midnight-sun-icons (see ../README.md, "Mac app icons").
#   apply-icons.sh           apply any missing icon
#   apply-icons.sh --check   change nothing; exit 1 if an installed app lacks its icon
set -uo pipefail
export PATH="/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"
HERE="${0:A:h}"
STATE="$HOME/Library/Application Support/midnight-sun/icons"

# app path -> PNG. Add a line to cover another app.
typeset -A ICONS=(
  /Applications/Firefox.app "$HERE/firefox.png"
  /Applications/Claude.app  "$HERE/claude.png"
  /Applications/iTerm.app   "$HERE/iterm2.png"
  /Applications/Discord.app "$HERE/discord.png"
  /Applications/Linear.app  "$HERE/linear.png"
  /Applications/Logseq.app  "$HERE/logseq.png"
  /Applications/Signal.app  "$HERE/signal.png"
  /Applications/Spotify.app "$HERE/spotify.png"
  /Applications/Sync.app    "$HERE/sync.png"
  "/Applications/Google Chrome.app" "$HERE/chrome.png"
  "/Applications/Visual Studio Code.app" "$HERE/vscode.png"
)

check_only=0
[[ "${1:-}" == "--check" ]] && check_only=1
log() { print "$(date '+%F %T') $*"; }
command -v fileicon >/dev/null || { log "fileicon not found (brew install fileicon)"; exit 2; }
mkdir -p "$STATE"

missing=0
for app png in "${(@kv)ICONS}"; do
  name="${app:t:r}"
  stamp="$STATE/$name.sha256"
  if [[ ! -d "$app" ]]; then log "$name: not installed, skipped"; continue; fi
  if [[ ! -f "$png" ]]; then log "$name: $png missing"; missing=1; continue; fi
  want="$(shasum -a 256 "$png" | cut -d' ' -f1)"
  # A custom icon is in place AND it was applied from this exact PNG.
  if fileicon test "$app" >/dev/null 2>&1 && [[ "$(cat "$stamp" 2>/dev/null)" == "$want" ]]; then
    (( check_only )) || log "$name: already set"
    continue
  fi
  if (( check_only )); then log "$name: custom icon missing or out of date"; missing=1; continue; fi
  # Keep whatever custom icon was there before we replace it (once).
  if fileicon test "$app" >/dev/null 2>&1 && [[ ! -f "$STATE/$name.previous.icns" ]]; then
    fileicon get "$app" "$STATE/$name.previous.icns" >/dev/null 2>&1
  fi
  if fileicon set "$app" "$png" >/dev/null; then
    print -n "$want" > "$stamp"
    log "$name: icon applied"
  else
    log "$name: fileicon set failed"; missing=1
  fi
done
exit $missing
