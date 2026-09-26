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
link bin/mcp-logseq  ~/.local/bin/mcp-logseq
link vscode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"

# Midnight Sun theme (themes/midnight-sun; edit palette.json, run build.py)
link themes/midnight-sun/vscode ~/.vscode/extensions/nickjmorrow.midnight-sun-1.0.0
link themes/midnight-sun/iterm-profile.json "$HOME/Library/Application Support/iTerm2/DynamicProfiles/midnight-sun.json"
defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "6d1e2a4c-midnight-sun-roland"

if [[ ! -d ~/.oh-my-zsh ]]; then
  git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
fi
