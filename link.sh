#!/usr/bin/env zsh
# Symlink these dotfiles into ~. Safe to re-run; an existing real file is
# moved aside to <name>.backup rather than overwritten.
set -euo pipefail
DOTFILES="${0:A:h}"

link() {
  local src="$DOTFILES/$1" dest="$2"
  mkdir -p "${dest:h}"
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    return
  fi
  if [[ -e "$dest" || -L "$dest" ]]; then
    mv "$dest" "$dest.backup"
    print "Moved existing $dest to $dest.backup"
  fi
  ln -s "$src" "$dest"
  print "Linked $dest"
}

link zshrc           ~/.zshrc
link global_gitignore ~/.config/git/ignore
link claude/agents     ~/.claude/agents
link opencode/opencode.json ~/.config/opencode/opencode.json
link skhd/skhdrc        ~/.config/skhd/skhdrc
link vscode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"

# Midnight Sun theme (themes/midnight-sun; edit palette.json, run build.py)
link themes/midnight-sun/vscode ~/.vscode/extensions/nickjmorrow.midnight-sun-1.0.0
link themes/midnight-sun/iterm-profile.json "$HOME/Library/Application Support/iTerm2/DynamicProfiles/midnight-sun.json"
# Mac app icons: a LaunchAgent re-applies them after apps update (see themes/midnight-sun/README.md).
# Not on a work Mac (mac-setup's `setup.sh --work` writes this file): no background job rewriting app icons there.
if [[ "$(cat ~/.config/mac-setup/profile 2>/dev/null)" != work ]]; then
  link themes/midnight-sun/mac/com.nicholai.midnight-sun-icons.plist ~/Library/LaunchAgents/com.nicholai.midnight-sun-icons.plist
  if ! launchctl print "gui/$UID/com.nicholai.midnight-sun-icons" >/dev/null 2>&1; then
    launchctl bootstrap "gui/$UID" ~/Library/LaunchAgents/com.nicholai.midnight-sun-icons.plist
  fi
fi
# Night: warm, low-contrast iTerm profile (iterm/night.json), the default
link iterm/night.json "$HOME/Library/Application Support/iTerm2/DynamicProfiles/night.json"
defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "night-roland"

if [[ ! -d ~/.oh-my-zsh ]]; then
  git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
fi
