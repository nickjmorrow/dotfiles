# git aliases
git config --global core.editor "code --wait"
git config --global alias.fr "!git fetch && git rebase -i origin/master"
git config --global alias.hist "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"
git config --global alias.s 'status'

# bash aliases for git
alias g='git'
# this overwrites GhostScript
alias gs='git status'
alias gac='git add -A && git commit -m '
alias gcom='git checkout master && git pull'

function gacp() {
	gac "$1"
	git push
}