# functions
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# terminal colors and prompt
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad
export PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]\n\[\033[35m\]\u \[\033[35m\]\[\033[32m\]\W\[\033[36m\]`__git_ps1`\[\033[0m\]\n$ '