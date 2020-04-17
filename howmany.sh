#!/bin/bash
# Keep track of how much I commit in the day
# also redirects output to clip.exe for easy paste out of WSL

# usage:
#   $ ~/tools/howmany.sh [-c]
# Displays what I did today.
#   -c: copy output to clipboard, for pasting elsewhere in Windows

ROOT=~
WDIR=~/tools
DDIR=$WDIR/data
FILE=$DDIR/commits.`date +%Y-%m-%d`.txt
TEMP=$DDIR/temp

# list the day's logs for 1 git project into a file
daylog() {
    PROJECT=${PWD##*/}
    YEAR=`date +%Y`
    LEN=70 # 20 chars for datetime, 50 for max git comment length
    git log --pretty --format="%ci %s" --since=midnight | \
      sed "s/+0[12]00 //" | cut -c -$LEN | sed "s/^$YEAR-//" | \
	  sed "s/$/ >$PROJECT/" >> $FILE
}

# list the day's logs for a list of git projects into a file
rm -f $FILE $TEMP
for repo in svelte-demo svelte-demo-debug lapeste sovelte blog yuansu-react git-sum jamstack-comments-engine vizhubbarchart todo tools uketabs
do
    cd $ROOT/$repo; daylog
done

# print all the day's logs, in order
cat $FILE | cut -c 6- | sed 's/^ 0/  /' | sort | tee -a $TEMP

# repos
echo " "`cat $FILE | cut -d\> -f 2- | sort -u | tr -s '\n' ' '` | tee -a $TEMP
# hours, redundant with half-hours
#echo " "`cat $FILE | cut -d' ' -f 2 | cut -d: -f 1 | sort -u | tr -s '\n' ' '` | tee -a $TEMP
# half hours
echo `cat $FILE | cut -d' ' -f 2 | cut -c -4 | sed 's/:[0-2]/↑/' | sed 's/:[3-5]/↓/' | sort -u | tr -s '\n' ' '` | sed 's/\([0-2][0-9]\)↑ \1↓/\1↑↓/g' | tee -a $TEMP

# overall summary of the day's activity
# need to integrate 15-min slots with ← and →
echo `date +'%A %e %B, by %H:%M'` did `cat $FILE | sort | wc -l` commits \
     in `cat $FILE | cut -d\> -f 2- | sort -u | wc -l` repos \
     at `cat $FILE | cut -d' ' -f 2 | cut -d: -f 1 | sort -u | wc -l` \
     ≠ hours, \
     `cat $FILE | cut -d' ' -f 2 | cut -c -4 | sed 's/:[0-2]/↑/' | sed 's/:[3-5]/↓/' | sort -u | wc -l` \
     ≠ half-hours \
     | tee -a $TEMP

if [ "$1" = "-c" ]
then
    >&2 echo '(also copied output to clipboard)'
    cat $TEMP | clip.exe
fi
