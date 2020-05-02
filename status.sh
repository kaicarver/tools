#!/bin/bash
# Some commands I use from my history and don't want to lose

# list of projects, shared by other scripts
source $(dirname "$0")/projects.sh

cd ~

# more status about list of projects
for repo in $PROJECTS
do
    if [ -d "$repo" ]; then
	echo $repo : `git -C $repo status | grep ahead`
    fi
done

# push it
#for r in blog leaflet clock geotools bootcamp_python_kai lapeste yuansu-react uketabs tools; do echo $r : `git -C $r push`; done
