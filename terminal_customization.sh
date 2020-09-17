# functions
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# terminal colors and prompt
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad
export PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]\n\[\033[1;35m\]\u \[\033[1;35m\]\[\033[1;33m\]\W\[\033[1;36m\]`__git_ps1`\[\033[0m\]\n$ '