# functions
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# terminal colors and prompt
export PS1='\e[0;35m[\w] $(parse_git_branch) \e[m \e[1;35m$\e[m '
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad
export PS1='\n\[\e[0;36m\]\w\e[m\e[0;35m$(parse_git_branch)\e[m\e[0;32m\n$ \[\e[m\]'