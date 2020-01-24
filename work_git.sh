export EDITOR='code'
export SVN_EDITOR='code'

export TRSBASE='https://fora164temp.forafinancial.com:9443/svn/ForaFinancial-V2.1/TRS/TRSIII'

export SVNTRUNK="$TRSBASE/trunk"
export BRANCHROUTE=$"branches/Nicholas.Morrow"

# switch to trunk
alias svn-home='svn switch $SVNTRUNK'

# get last 3 commits
alias svn-recent='svn log -l 3'

# get current branch name
alias svn-cur="svn info | grep '^URL:'"

alias svn-d="svn diff --summarize"

# switch to branch with name $1
function svnco() {
	svn switch $TRSBASE/branches/Nicholas.Morrow/$1
}

# create copy from trunk
function svncopy() {
	svn-home && svn update && svn copy $SVNTRUNK "$TRSBASE/$BRANCHROUTE/$1" --non-interactive -m "$2"
}

# svn copy $SVNTRUNK "$TRSBASE/$BRANCHROUTE/us-16924" --non-interactive -m "Create branch for US-16924."