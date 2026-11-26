#!/bin/zsh
# Plates for apps installed as root (App Store and admin installers). fileicon can't write to them as the user,
# so the hourly LaunchAgent skips them; run this by hand with sudo after one of them updates:
#   sudo ~/Projects/dotfiles/themes/midnight-sun/mac/admin/apply-admin-icons.sh
set -u
HERE="${0:A:h}"
FILEICON=/opt/homebrew/bin/fileicon
typeset -A ICONS=(
  /Applications/Bitwarden.app   "$HERE/bitwarden.png"
  /Applications/Fantastical.app "$HERE/fantastical.png"
  /Applications/Immich.app      "$HERE/immich.png"
  /Applications/Slack.app       "$HERE/slack.png"
  /Applications/Tailscale.app   "$HERE/tailscale.png"
)
for app png in "${(@kv)ICONS}"; do
  if [[ ! -d "$app" ]]; then print "${app:t:r}: not installed"; continue; fi
  "$FILEICON" set "$app" "$png" >/dev/null && print "${app:t:r}: icon applied" || print "${app:t:r}: failed"
done
killall Dock 2>/dev/null
