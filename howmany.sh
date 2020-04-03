#!/bin/sh
# Keep track of how much I commit in the day

FILE=commits.`date +%Y-%m-%d`.txt
daylog() {
    PROJECT=${PWD##*/}
    YEAR=`date +%Y`
    git log --pretty --format="%ci %s" --since=midnight | \
	sed "s/+0[12]00 //" | cut -c -76 | sed "s/^$YEAR-//" | \
	sed "s/$/ >$PROJECT/"  >> ../$FILE
}

cd
rm -f $FILE

for repo in svelte-demo svelte-demo-debug lapeste sovelte blog yuansu-react git-sum jamstack-comments-engine vizhubbarchart todo
do
    cd $repo; daylog; cd ..
done

cat $FILE | sort

cat $FILE | cut -d\> -f 2- | sort -u

echo did `cat $FILE | sort | wc -l` commits \
     in `cat $FILE | cut -d\> -f 2- | sort -u | wc -l` different repos \
     at `cat $FILE | cut -d' ' -f 2 | cut -d: -f 1 | sort -u | wc -l` \
     different hours of the day.

cat $FILE | cut -d' ' -f 2 | cut -d: -f 1 | sort -u | tr -s '\n' ' '
echo
echo It\'s `date +%H:%M`
