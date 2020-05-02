#!/bin/bash
# Some commands I use from my history and don't want to lose

# list of projects, shared by other scripts
source $(dirname "$0")/projects.sh

cd ~

# push all projects
for repo in $PROJECTS
do
    if [ -d "$repo" ]; then
	echo -n $repo ": "
	git -C $repo push
    fi
done

