#!/bin/bash
# pull all my projects

# list of projects, shared by other scripts
source $(dirname "$0")/projects.sh

cd ~

# push all projects
for repo in $PROJECTS
do
    if [ -d "$repo" ]; then
        echo -n $repo ": "
        git -C $repo pull --no-rebase
    fi
done

