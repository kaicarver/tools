# Implementation notes

- [Implementation notes](#implementation-notes)
  - [howmany.sh](#howmanysh)
    - [TODOS](#todos)
      - [option to specify day](#option-to-specify-day)
      - [report on previous days](#report-on-previous-days)
      - [publish to the web](#publish-to-the-web)
      - [option of more detail about each commit](#option-of-more-detail-about-each-commit)
      - [every 15 minutes report](#every-15-minutes-report)
    - [Other](#other)

## howmany.sh

### TODOS

#### option to specify day

in the `daylog` function, there should be an option to see the logs of a specific day,
using parameters of the form:

```bash
   git log --after="2013-11-12 00:00" --before="2013-11-13 00:00"
```

instead of

```bash
   git log --since=midnight
```

#### report on previous days

currently only gives info about today.

What were past days, week, average, etc?

#### publish to the web

publish to web! what's easiest way to do that? eleventy?

#### option of more detail about each commit

optional more detail about each commit: what files modified, how many lines...

#### every 15 minutes report

we have every hour, every half hour... Let's have how many separate 15 minute slot to keep going this "inverse-Pomodoro" route.

And yeah, this shell script is getting unwieldy, but let's try to keep this a small mod, and not have to rewrite the4 whole thing in Perl or whatnot.

### Other

don't need this, but it's a clever bash trick to redirect stdout to multiple processes

```bash
 some_program_with_stdout | tee >(clip.exe) >(cmd2) >(cmd3) [...]
```
