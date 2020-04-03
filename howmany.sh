#!/bin/sh
# Keep track of how much I commit in the day

ROOT=~
WDIR=~/tools
DDIR=$WDIR/data
FILE=$DDIR/commits.`date +%Y-%m-%d`.txt

# list the day's logs for 1 git project into a file
daylog() {
    PROJECT=${PWD##*/}
    YEAR=`date +%Y`
    git log --pretty --format="%ci %s" --since=midnight | \
      sed "s/+0[12]00 //" | cut -c -76 | sed "s/^$YEAR-//" | \
	  sed "s/$/ >$PROJECT/" >> $FILE
}

# list the day's logs for a list of git projects into a file
rm -f $FILE
for repo in svelte-demo svelte-demo-debug lapeste sovelte blog yuansu-react git-sum jamstack-comments-engine vizhubbarchart todo tools
do
    cd $ROOT/$repo; daylog
done

# print all the day's logs, in order
cat $FILE | sort

# print all the repos that had commits
cat $FILE | cut -d\> -f 2- | sort -u

# overall summary of the day's activity
echo did `cat $FILE | sort | wc -l` commits \
     in `cat $FILE | cut -d\> -f 2- | sort -u | wc -l` different repos \
     at `cat $FILE | cut -d' ' -f 2 | cut -d: -f 1 | sort -u | wc -l` \
     different hours \
     and `cat $FILE | cut -d' ' -f 2 | cut -c -4 | sed 's/:[0-2]/↑/' | sed 's/:[3-5]/↓/' | sort -u | wc -l` \
     different half-hours of the day

cat $FILE | cut -d' ' -f 2 | cut -d: -f 1 | sort -u | tr -s '\n' ' '
echo
cat $FILE | cut -d' ' -f 2 | cut -c -4 | sed 's/:[0-2]/↑/' | sed 's/:[3-5]/↓/' | sort -u | tr -s '\n' ' '
echo
echo It\'s `date +%H:%M`
