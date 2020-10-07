#!/bin/bash
# Some commands I use from my history and don't want to lose

# list of projects, shared by other scripts
source $(dirname "$0")/projects.sh

cd ~

# more status about list of projects
verbose=0
if (( verbose > 0 )); then
    echo in the following projects:
    echo   $PROJECTS
    echo
fi
for repo in $PROJECTS
do
    if [ -d "$repo" ]; then
        todo=`git -C $repo status | egrep 'ahead|Changes|untracked|Untracked'\
                | sed 's/Your branch is ahead of .origin.master./ahead/' \
                | sed 's/:/./g' | sed 's/\n/ /g'`
        if [ "$todo" != "" ] ; then
            echo $repo : $todo | tr '[:upper:]' '[:lower:]'
        fi
    fi
done
