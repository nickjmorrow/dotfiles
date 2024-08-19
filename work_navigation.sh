# General commands
alias zaws='aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 734818345323.dkr.ecr.us-east-1.amazonaws.com'
alias zrun='zen && zaws && ./run-local.sh && ./seed_db.sh'
alias zenp='projects && cd zenlytic-plots'
alias zlogs='docker-compose -f docker-compose-dev.yml logs --tail 2000 | grep worker_1'
alias zdown='docker-compose -f docker-compose-dev.yml down'
alias zen='projects && cd zenlytic'
alias zenf='zen && cd services/front_end'
alias zen2='projects && cd zenlytic_2'
alias zenf2='zen2 && cd services/front_end'


# General folder navigation
alias gdrive='cd ~/"Google Drive"'
alias inotes='gdrive && cd issue_notes'
alias projects='cd ~/Projects'
alias dotfiles='projects && cd dotfiles'
alias vdotfiles='vim ~/Projects/dotfiles'
