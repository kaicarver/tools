#!/bin/bash
# Keep track of how much I commit in the day
# also redirects output to clip.exe for easy paste out of WSL

# TODO: optional more detail about each commit: what files modified, how many lines...
# TODO: publish to web! what's easiest way to do that?

ROOT=~
WDIR=~/tools
DDIR=$WDIR/data
FILE=$DDIR/commits.`date +%Y-%m-%d`.txt
TEMP=$DDIR/temp

# list the day's logs for 1 git project into a file
daylog() {
    PROJECT=${PWD##*/}
    YEAR=`date +%Y`
    git log --pretty --format="%ci %s" --since=midnight | \
      sed "s/+0[12]00 //" | cut -c -76 | sed "s/^$YEAR-//" | \
	  sed "s/$/ >$PROJECT/" >> $FILE
}

# list the day's logs for a list of git projects into a file
rm -f $FILE $TEMP
for repo in svelte-demo svelte-demo-debug lapeste sovelte blog yuansu-react git-sum jamstack-comments-engine vizhubbarchart todo tools
do
    cd $ROOT/$repo; daylog
done

# print all the day's logs, in order
cat $FILE | cut -c 6- | sed 's/^ 0/  /' | sort | tee -a $TEMP

# overall summary of the day's activity
echo did `cat $FILE | sort | wc -l` commits \
     in `cat $FILE | cut -d\> -f 2- | sort -u | wc -l` ≠ repos \
     at `cat $FILE | cut -d' ' -f 2 | cut -d: -f 1 | sort -u | wc -l` \
     ≠ hours \
     and `cat $FILE | cut -d' ' -f 2 | cut -c -4 | sed 's/:[0-2]/↑/' | sed 's/:[3-5]/↓/' | sort -u | wc -l` \
     ≠ half-hours of the day \
     | tee -a $TEMP

# repos
echo " "`cat $FILE | cut -d\> -f 2- | sort -u | tr -s '\n' ' '` | tee -a $TEMP
# hours
echo " "`cat $FILE | cut -d' ' -f 2 | cut -d: -f 1 | sort -u | tr -s '\n' ' '` | tee -a $TEMP
# half hours
echo " "`cat $FILE | cut -d' ' -f 2 | cut -c -4 | sed 's/:[0-2]/↑/' | sed 's/:[3-5]/↓/' | sort -u | tr -s '\n' ' '` | tee -a $TEMP
echo It\'s `date +%H:%M` | tee -a $TEMP
cat $TEMP | clip.exe

# don't need this, but it's a clever bash trick to redirect stdout to multiple processes
# cat $TEMP | tee >(clip.exe) >(cmd2) >(cmd3) ...