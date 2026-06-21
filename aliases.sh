## a quick way to get out of current directory ##
alias ..='cd ..'
alias ...='cd ../../..'
alias ....='cd ../../../..'
alias .....='cd ../../../../..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

alias s="source ~/.zshrc"

alias codexy="codex --dangerously-bypass-approvals-and-sandbox"
alias claudey="claude --dangerously-skip-permissions"

alias l='ls -lFogG'
alias la='ls -lAFogG'
alias lart='ls -lArtFogG'

alias path='echo -e ${PATH//:/\\n}'

alias diffgui=opendiff

alias csp='cloud_sql_proxy -instances=vinli-dev-eu:europe-west1:dev-postgres-01=tcp:5432'

alias deploy='fastlane build_and_deploy_ios'

alias dbb='"/Applications/DB Browser for SQLite.app/Contents/MacOS/DB Browser for SQLite"'
alias dc='docker-compose'

# you must already have parent repository's .gitsubmodule's entries with the branch 
# ex: git config -f .gitmodules submodule.<name>.branch <branch>

alias gs="git_status"
alias gco="git checkout"
alias gs="git status --short"
alias gd="git diff"
alias gp="git push"
alias gu="git pull --rebase"
