# TCL shortcuts
alias tcl='projects && cd component-library'
alias sandbox='tcl && cd sandbox'

alias tcl2='projects && cd component-library-2'
alias sandbox2='tcl2 && cd sandbox'

alias tcl3='projects && cd component-library-3'
alias sandbox3='tcl3 && cd sandbox'

# LIMS navigation shortcuts
alias limsux='cd ~/Projects/lims-ux/code'
alias limssvc='cd ~/Projects/lims-service/code'
alias limsservice='limssvc'
alias limsshared='limssvc && cd src/shared'
alias limsdocs='cd ~/Projects/lims-docs'

# General folder navigation
alias gdrive='cd ~/"Google Drive"'
alias inotes='gdrive && cd issue_notes'
alias projects='cd ~/Projects'
alias dotfiles='projects && cd dotfiles'
alias vdotfiles='vim ~/Projects/dotfiles'

# DBAProxy shortcuts
alias refresh_dbaproxy='ssh-keygen -R dbaproxy.devtempus.com; ssh-keygen -R dbaproxy.securetempus.com'
alias dbaproxy_uat='ssh -N -L 5431:lims-service-data-uat.cluster-clatowau039y.us-west-2.rds.amazonaws.com:5432 nicholas.morrow@dbaproxy.devtempus.com'
alias dbaproxy_staging='ssh -N -L 5431:lims-service-data-staging.cluster-clatowau039y.us-west-2.rds.amazonaws.com:5432 nicholas.morrow@dbaproxy.devtempus.com'
alias dbaproxy_mtstaging='ssh -N -L 5428:tl-uzk33rn4ll3a2cieh573:us-west1:lims-ddda29b5=tcp:3306 nicholas.morrow@dbaproxy.devtempus.com'
alias dbaproxy_prod='ssh -N -L 5430:lims-service-data-production.cluster-c5vznkm3wdcg.us-east-1.rds.amazonaws.com:5432 nicholas.morrow@dbaproxy.securetempus.com'
alias dbaproxy_prodro='ssh -N -L 5430:lims-service-data-production-read-replica.c5vznkm3wdcg.us-east-1.rds.amazonaws.com:5432 nicholas.morrow@dbaproxy.securetempus.com'

# Okta shortcuts
alias okta_staging='okta-personal-token get --default-scopes preview/sundial-staging | pbcopy | echo "Token copied to clipboard."'
alias okta_prod='okta-personal-token get --default-scopes prod/sundial-production | pbcopy | echo "Token copied to clipboard".' 
