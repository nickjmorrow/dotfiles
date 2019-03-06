# cd navigation
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'

# navigation
alias projects='cd ~/Projects'

alias downloads='cd ~/Downloads'
alias projects='cd ~/Projects'

alias notes='projects && cd notes'
alias opennotes='code ~/Projects/notes'

alias professional='notes && cd professional'
alias openprofessional='code ~/Projects/notes/professional'

alias dotfiles='cd ~/Projects/dotfiles'
alias opendotfiles='code ~/Projects/dotfiles'


# config access
alias bashrc='code ~/.bashrc'
alias rebash='source ~/.bashrc'
alias hyperjs='code ~/.hyper.js'


# functions
function cdl() {
	cd $1 && ls -Gp
}

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# terminal colors and prompt
# export PS1='\e[0;35m[\w] $(parse_git_branch) \e[m \e[1;35m$\e[m '
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad
export PS1='\[\e[35m\]\n\w\n$ \[\e[0m\]'