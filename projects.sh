#!/bin/bash
# git repos I am currently working on

PROJECTS="svelte-demo svelte-demo-debug lapeste sovelte blog \
    yuansu-react git-sum jamstack-comments-engine vizhubbarchart \
    todo tools uketabs clock bootcamp_python_kai geotools leaflet \
    sedfugit laravel zi hbd nextjs-blog csf amplify/postagram \
    textapi ytplayer worldword kaicarver.github.io fastai fastaixp \
    kaicarver scrape learn-tachyons fastbook blitzy"

PROJECTS=$(echo $PROJECTS | tr " " "\n" | sort)
