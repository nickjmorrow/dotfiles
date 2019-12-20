## wttr.in aliases
alias wthr='curl wttr.in'
alias moon='curl wttr.in/Moon'

# heroku
function heroku_deploy() {
	heroku container:push web -a $1 && heroku container:release web -a $1
}