alias external='cd ~/external'
alias dotfiles='external && cd dotfiles'
alias prof='external && cd professional-notes'
alias tech='external && cd technical-notes'

alias projects='cd ~/../../Projects'
alias trs='projects && cd TRS'
alias oma='projects && cd OMA'
alias dnc='projects && cd DNC'
alias admin='projects && cd Admin'
alias trs2='projects && cd TRS2'
alias postman='projects && cd postmanrepo'

alias wahk='code ~/external/dotfiles/work_hot_key_scripts.ahk'
alias dbup='~/../../Projects/TRS/TRS.DbUp/bin/Debug/TRS.DbUp'
alias dirman='~/../../Projects/TRS/TRS.DirectoryManagement/bin/Debug/TRS.DirectoryManagement'

alias hyperjs='code ~/AppData/Roaming/Hyper/.hyper.js'

# update git ignore status for TRS
trs && git update-index --assume-unchanged TRSIII.Site/Web.config
# navigate back to projects
projects