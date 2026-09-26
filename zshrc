# ~/.zshrc — symlinked from ~/Projects/dotfiles/zshrc by link.sh.
# Secrets and machine-specific settings go in ~/.zshrc.local (never committed).

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

export PATH="$HOME/.local/bin:$PATH"

source ~/Projects/dotfiles/index.sh
source ~/Projects/dotfiles/personal_index.sh
source ~/Projects/dotfiles/work_index.sh

command -v fzf >/dev/null && source <(fzf --zsh)

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
