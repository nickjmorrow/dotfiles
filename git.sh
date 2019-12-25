# git aliases
git config --global core.editor "code --wait"
git config --global alias.fr "!git fetch && git rebase -i origin/master"
git config --global alias.amend "commit --amend"
git config --global alias.master "checkout master" 
git config --global alias.hist "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"

# bash aliases for git
alias g='git'
alias gs='git status'
alias gac='git add -A && git commit -m '
alias gcom='git checkout master && git pull'

function gacp() {
	gac "$1"
	git push
}