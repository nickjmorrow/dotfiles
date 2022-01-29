export EDITOR='code'

alias g='git'

alias gs='git status'

# git aliases
git config --global core.editor "code --wait"
git config --global alias.fr "!git fetch && git rebase -i origin/master"
git config --global alias.hist "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short --decorate"
git config --global alias.s 'status'
git config --global alias.c 'commit'
git config --global alias.co 'checkout'
git config --global alias.cob 'checkout -b'
git config --global alias.unstage 'reset --soft HEAD^'

# bash aliases for git


alias gcom='git checkout master && git pull'
alias gcod='git checkout develop && git pull'
alias gcpf='git commit --amend --no-edit && g push -f'
alias gac='git add -A && git commit -m '

# add and commit all changes. dangerous
function gacp() {
	gac "$1"
	git push
}
