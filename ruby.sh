rvm use ruby-2.7.2

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

if [[ -e "${HOME}/.rvm/scripts/rvm" ]]; then
       source ${HOME}/.rvm/scripts/rvm
fi

#export GEM_HOME=$HOME/gems
export PATH=$GEM_HOME/bin:$PATH