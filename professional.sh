# base
alias platform='cd ~/../../dev/platform'

# aid 
alias aidrepo='platform && cd aid'
alias aid='aidrepo && cd AnalyticsInsightsData'
alias scripts='aid && cd Apt.Platform.AnalyticsInsightsData.Web/Scripts'
alias aidjs='scripts'
alias aidweb='scripts'
alias aidcalc='aidrepo && cd AidCalc'
alias aiddu='aidrepo && cd AidDataUsage'

# transaction attributes
alias ta='platform && cd aidtransactionattributescalc'
alias tacodes='platform cd transactionattributecodes'

# data management
alias dm='platform && cd aiddatamanagement/AidDataManagement'
alias dmweb='dm && cd Apt.Platform.AidDataManagement.Web/Scripts'
alias dmjs='dmweb'

# mastermind
alias mm='web && cd mastermindScripts'
alias mmweb='mm'
alias mmjs='mm'

# functions
function mkconfig() {
	sh ~/../../dev/platform/aid/Scripts/create-configurable-script.sh "$1" "$2"
}
