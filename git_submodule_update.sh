#!/bin/sh 
#
# you must already have parent repository's .gitsubmodule's entries with the branch 
# ex: git config -f .gitmodules submodule.<name>.branch branch

alias git_submodule_update="git submodule foreach -q --recursive 'branch="$(git config -f $toplevel/.gitmodules submodule.$name.branch)"; git checkout $branch; git pull;'"