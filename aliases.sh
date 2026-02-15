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
alias l='ls -lFogG'
alias la='ls -lAFogG'
alias lart='ls -lArtFogG'

alias path='echo -e ${PATH//:/\\n}'

alias diffgui=opendiff

# you must already have parent repository's .gitsubmodule's entries with the branch 
# ex: git config -f .gitmodules submodule.<name>.branch <branch>

alias gs="git_status"
alias gco="git checkout"
alias gs="git status --short"
alias gd="git diff"
alias gp="git push"
alias gu="git pull --rebase"

alias settitle='echo -ne "\033]1;${1}\007"'

alias ow="open OneApp.xcworkspace"
