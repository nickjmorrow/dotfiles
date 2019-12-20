# base
alias platform='cd ~/../../dev/platform'

# aid 
alias aid='cd ~/../../dev/platform/aid/AnalyticsInsightsData'
alias web='aid && cd Apt.Platform.AnalyticsInsightsData.Web'
alias scripts='aid && cd Apt.Platform.AnalyticsInsightsData.Web/Scripts'
alias aidjs='scripts'
alias aidweb='scripts'
alias aidcalc='aidrepo && cd AidCalc'
alias aiddu='aidrepo && cd AidDataUsage'

# transaction attributes
alias ta='platform && cd aidtransactionattributescalc'
alias tacodes='platform cd transactionattributecodes'

# data management
alias adm='platform && cd aiddatamanagement/AidDataManagement'
alias admweb='adm && cd Apt.Platform.AidDataManagement.Web/Scripts'
alias admjs='admweb'

# mastermind
alias mm='web && cd mastermindScripts'
alias mmweb='mm'
alias mmjs='mm'

# functions
function mkconfig() {
	sh ~/../../dev/platform/aid/Scripts/create-configurable-script.sh "$1" "$2"
}
