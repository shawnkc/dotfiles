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

# use ios7 sdk from xcode 5 dir in xcode 6
XCODE6_PACKAGE=/Applications/Xcode.app
XCODE5_PACKAGE=/Applications/Xcode5.1.1.app
alias link_ios7='sudo ln -s "${XCODE5_PACKAGE}/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk" "${XCODE6_PACKAGE}/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk"'