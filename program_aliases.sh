## wttr.in aliases
alias wthr='curl wttr.in'
alias moon='curl wttr.in/Moon'

# npm
alias nr='npm run'
alias yr='yarn run'
alias y='yarn'

# heroku
function heroku_deploy() {
	heroku container:push web -a $1 && heroku container:release web -a $1
}