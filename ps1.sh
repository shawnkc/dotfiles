# http://www.ibm.com/developerworks/linux/library/l-tip-prompt/
# http://beckism.com/2009/02/better_bash_prompt/

export CLICOLOR=1








bash_prompt_command() {
    RTN=$?
    prevCmd=$(prevCmd $RTN)
}
PROMPT_COMMAND=bash_prompt_command
prevCmd() {
    if [ $1 == 0 ] ; then
        echo $GREEN
    else
        echo $RED
    fi
}
if [ $(tput colors) -gt 0 ] ; then
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    RST=$(tput op)
fi

# export PS1="\[\e[36m\]\u.\h.\W\[\e[0m\]\[\$prevCmd\]>\[$RST\]"



parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
export -f parse_git_branch

export PS1="\[\033[36m\]\w\n\[\033[33m\]\$(parse_git_branch)\[\033[00m\]\[\$prevCmd\]$\[\033[00m\] "
# export PS1="\[\033[36m\]\h:\W \[\033[33m\]\$(parse_git_branch)\[\033[00m\]\[\$prevCmd\]$\[\033[00m\] "
export SUDO_PS1='\[\e[0;31m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[0;31m\]\$ \[\e[0m\]'



# export PS1="\[\e[1m\]________________________________________________________________________________\n\[\e[1;30;47m\]| \W @ \h (\u) \n| => \[\e[0m\]"
# export PS2="\[\e[1;30;47m\]| => \[\e[0m\]"




# export PS1="\[\e[36;1m\]\u@\[\e[32;1m\]\H> \[\e[0m\]"