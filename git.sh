#!/bin/sh
#
# you must already have parent repository's .gitsubmodule's entries with the branch 
# ex: git config -f .gitmodules submodule.<name>.branch <branch>

alias git_submodule_update="git submodule foreach -q --recursive 'branch="$(git config -f $toplevel/.gitmodules submodule.$name.branch)"; git checkout $branch; git pull;'"
alias git_submodule_status="git submodule foreach -q --recursive 'branch="$(git config -f $toplevel/.gitmodules submodule.$name.branch)"; echo; pwd; git status;'"
alias git_status="git status;git_submodule_status"
alias gs="git_status"
alias git_commit_sub="git commit -am 'sub';git push"

alias co="git checkout"
alias gs="git status"
