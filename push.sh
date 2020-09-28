#!/bin/bash
# push everything that needs to be pushed in all my projects

# list of projects, shared by other scripts
source $(dirname "$0")/projects.sh

cd ~

# push all projects
for repo in $PROJECTS
do
    if [ -d "$repo" ]; then
        # only push when branch is ahead of origin/master
        todo=`git -C $repo status | egrep 'ahead'`
        if [ "$todo" != "" ] ; then
            echo -n $repo ": "
            git -C $repo push
        fi
    fi
done

