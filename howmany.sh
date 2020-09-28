#!/bin/bash
# Keep track of how much I commit in the day.
#
# The idea is to give finer feedback on daily git commit activity
# than Github tiles.
#
# usage:
#   $ ~/tools/howmany.sh [-c]
# Displays what I did today.
#   -c: copy output to clipboard for easy paste out of WSL elsewhere in Windows
#
# TODO: get rid of duplicate code, prob. by moving more to Perl
# TODO: add the file (files, first file?) to the detailed log line,
#       to make comment more understandable
#       use something like git log --stat at a verbosity level of 4?

# list of projects, shared by other scripts
source $(dirname "$0")/projects.sh

ROOT=~
WDIR=~/tools
DDIR=$WDIR/data
TEMP=$DDIR/temp

usage() {
    prog=`basename $0`
    echo "Usage: $prog [-ch] [-d numdays] [-v level] [YYYY-MM-DD] [YYYY-MM-DD] ...
  Report on commits for a given day.
Examples:
  $prog              # today's commits, briefest version
  $prog "`date +'%Y-%m-%d'`"
  $prog 2020-09-18 2020-09-19 "`date +'%Y-%m-%d'`"  # several days
  $prog -v3 now      # today's info, max verbosity (0-3)
  $prog -v 1 -c now  # -c also copies the last day's output to clipboard" 1>&2 
}

exit_abnormal() {
  usage
  exit 1
}

# list the day's logs for 1 git project into a file
daylog() {
    PROJECT=${PWD##*/}
    YEAR=`date -d $day +%Y`
    LEN=70 # 20 chars for datetime, 50 for max git comment length
    git log --pretty --format="%ai %s" --since=${day}T00:00:00+02:00 --until=${day}T23:59:59+02:00 | \
      sed "s/+0[12]00 //" | cut -c -$LEN | sed "s/^$YEAR-//" | \
      sed "s/$/ >$PROJECT/" >> $FILE
}

verbose=0
while getopts "chd:v:" options; do
    case "${options}" in
        c) 
            clip=true
            ;;
        h)
            usage; exit
            ;;
        d)
            numdays=${OPTARG}
            ;;
        v) 
            verbose=${OPTARG}
            ;;
        *)
            exit_abnormal
            ;;
    esac
done
shift $((OPTIND-1))

if [ "$1" = "" ]; then
    set -- "now"  # this sets the command line to one arg: "now"
fi

if (( numdays > 0 )); then
    # TODO: just loop on: date +'%Y-%m-%d' -d"3 days ago"
    echo "-d option NYI but here's a taste:"
    set -- "2020-09-14" "2020-09-15" "2020-09-16" "2020-09-17" "2020-09-18" "2020-09-19" "2020-09-20" "2020-09-21" "2020-09-22" "2020-09-23" "2020-09-24"
fi

while [ "$1" ]; do
    if [ "$1" = "now" ]; then
        day=`date +'%Y-%m-%dT%H:%M:%S'`
    elif [[ "$1" =~ ^[1-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]$ ]]; then
        past=true
        day="$1"
    else
        echo ERROR: "parameter '$1' unrecognized"
        exit_abnormal
    fi

    FILE=$DDIR/commits.`date -d $day +%Y-%m-%d`.txt

    # list the day's logs for a list of git projects into a file
    rm -f $FILE $TEMP
    for repo in $PROJECTS
    do
        if [ -d "$ROOT/$repo" ]; then
            cd $ROOT/$repo; daylog
        fi
    done

    # overall summary of the day's activity
    # need to integrate 15-min slots with ← and → using an extra digit of time...
    #   cat data/commits.2020-04-17.txt | cut -d' ' -f 2 | cut -c -5

    # "slots" during which there is a commit, by hour, half hour, quarter hour
    if (( verbose >= 1 )); then
        slots=`cat $FILE | cut -d' ' -f 2 | cut -c -5 | \
            sed 's/:0[0-9]/↑/' | \
            sed 's/:1[0-4]/↑/' | \
            sed 's/:[0-2][0-9]/→/' | \
            sed 's/:3[0-9]/↓/' | \
            sed 's/:4[0-4]/↓/' | \
            sed 's/:[3-5][0-9]/←/' | \
            sed 'y/↑→↓←/←↑→↓/' | \
            sort -u | \
            sed 'y/←↑→↓/↑→↓←/' | \
            tr -s '\n' ' ' | \
            perl -Mutf8 -CS -pe 's/([0-2][0-9])([↑→↓←]+) \1([↑→↓←]+ ?)/\1\2\3/g; s/([0-2][0-9])([↑→↓←]+) \1([←↑→↓]+ ?)/\1\2\3/g'`
    fi

    if [ "$past" = true ]
    then
        hour=" "
    else
        hour=", by %H:%M,"
    fi

    echo `date -d $day +"%a %e %b$hour "` \
        `cat $FILE | cut -d' ' -f 2 | cut -d: -f 1 | sort -u | wc -l` \
        ≠ hours, \
        `cat $FILE | cut -d' ' -f 2 | cut -c -4 | \
        sed 's/:[0-2]/↑/' | \
        sed 's/:[3-5]/↓/' | \
        sort -u | wc -l` \
        ≠ ½, \
        `cat $FILE | cut -d' ' -f 2 | cut -c -5 | \
        sed 's/:0[0-9]/←/' | \
        sed 's/:1[0-4]/←/' | \
        sed 's/:[0-2][0-9]/↑/' | \
        sed 's/:3[0-9]/→/' | \
        sed 's/:4[0-4]/→/' | \
        sed 's/:[3-5][0-9]/↓/' | \
        sort -u | wc -l` \
        ≠ ¼, \
        total `cat $FILE | sort | wc -l` \
        commits \
        | tee -a $TEMP

    if (( verbose >= 1 )); then
        echo "  "$slots | tee -a $TEMP
    fi

    # which repositories have commits and how many
    if (( verbose >= 2 )); then
        echo "  in "`cat $FILE | cut -d\> -f 2- | sort -u | wc -l`" repos: "`cat $FILE | cut -d\> -f 2- | sort | uniq -c | sed 's/^[ ]*//g' | sed 's/ /\//g' | tr -s '\n' ' '` | tee -a $TEMP
    fi

    # print all the day's logs, in order
    if (( verbose >= 3 )); then
        cat $FILE | cut -c 7- | sed 's/^0/ /' | sort | tee -a $TEMP
    fi

    # print info about each file
    if (( verbose >= 4 )); then
        echo verbose level 4 NYI
        # could use something like this, but would have to do it in daylog...
        # git log --stat | egrep '^( [^ ].* \| |Date|    [^ ])' | sed 's/Date:   Mon Sep 21 //' | sed 's/ 2020 .0200//' | head
    fi

    shift
done

if [ "$clip" = true ]
then
    >&2 echo '(also copied output to clipboard)'
    cat $TEMP | clip.exe
fi
