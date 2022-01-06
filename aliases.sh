## a quick way to get out of current directory ##
alias ..='cd ..'
alias ...='cd ../../..'
alias ....='cd ../../../..'
alias .....='cd ../../../../..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

alias s=subl
alias l='ls -lFo'
alias la='ls -lAFo'
alias lart='ls -lArtFo'

alias path='echo -e ${PATH//:/\\n}'

alias diffgui=opendiff

alias csp='cloud_sql_proxy -instances=vinli-dev-eu:europe-west1:dev-postgres-01=tcp:5432'

alias deploy='fastlane build_and_deploy_ios'

alias dbb='"/Applications/DB Browser for SQLite.app/Contents/MacOS/DB Browser for SQLite"'
alias dc='docker-compose'