#!/bin/bash
# Some commands I use from my history and don't want to lose

# list of projects, shared by other scripts
source $(dirname "$0")/projects.sh

cd ~

# more status about list of projects
for repo in $PROJECTS
do
    if [ -d "$repo" ]; then
        foo=`git -C $repo status | egrep 'ahead|Changes'` ;
        if [ "$foo" != "" ] ; then
            echo "<$foo>"
            echo $repo : `git -C $repo status | egrep 'ahead|Changes' \
                | sed 's/Your branch is ahead of .origin.master./ahead/' \
                | sed 's/:/./g'`
        fi
    fi
done
