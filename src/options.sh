#!/bin/sh
# shellcheck disable=SC2034

options() {
  #| # today
  #|
  #| A calendar/reminder/to-do system that just says what to do today!
  #|
  #| It works by reading from a plain text file formatted with markdown and
  #| additional syntax to describe tasks.

  while :; do
    case "$1" in
      #|
      #| ## Options
      #|
      #| today [OPTION] ..
      #|
      #| Options may be either the traditional POSIX one letter options,
      #| or the GNU style long options. POSIX style options start with a
      #| single `-`, while GNU long options start with `--`. Option
      #| arguments (if needed) follow separated by whitespace (not `=`).
      #|

      [-+][[:digit:]]*)
        #| **[-+][0-9]+**
        #|     Use date offset by N days from current set date.
        #|     For example `today -1` will show yesterday and
        #|     `today +1` will show tomorrow.
        #|
        if ! printf '%s' "$1" | grep -Eq '^[-+][0-9]+$'; then
          error 1 "Error: Invalid number: $1"
        fi
        OFFSET="$1"
        shift
        ;;

      -d | --date)
        #| **-d**, **--date** _YYYY-MM-DD_
        #|     Use given date instead of the current date.
        #|
        if ! printf '%s' "$2" | grep -Eq '[[:digit:]]{4}-[0-1][[:digit:]]-[0-3][[:digit:]]'; then
          error 1 "Error: Invalid date: $2"
        fi
        DATE="$2"
        shift 2
        ;;

      -f | --file)
        #| **-f**, **--file** _FILE_
        #|     Read tasks from FILE instead of the default ./todo.md.
        #|
        if test ! -f "$2"; then
          error 1 "Error: File not found: $2"
        fi
        TODO="$2"
        shift 2
        ;;

      -p | --priority)
        #| **-p**, **--priority** _LEVEL_
        #|     Display tasks with priority LEVEL where level is one of
        #|     A-Z or off to disable priority task display.
        #|
        if ! printf '%s' "$2" | grep -Eq '([A-Z]|off)'; then
          error 1 "Error: Invalid priority level: $2"
        fi
        PRIORITY="$2"
        shift 2
        ;;

      -s | --start)
        #| **-s**, **--start** _HH:MM_
        #|     Use HH:MM as start of the day when sorting scheduled
        #|     tasks. HH:MM should be in 24-hour time format for
        #|     proper sorting. The default start of the day is 04:30.
        #|
        if ! printf '%s' "$2" | grep -Eq '^[012][[:digit:]]:[012345][[:digit:]]$'; then
          error 1 "Error: Invalid time: $2"
        fi
        START="$(printf '%s' "$2" | tr -d ':')"
        shift 2
        ;;

      -t | --tag)
        #| **-t**, **--tag** _TAG_
        #|     List all tasks containing +TAG.
        #|
        PRIORITY='off'
        TAG="$2"
        shift 2
        ;;

      -T | --tags)
        #| **-T**, **--tags**
        #|     List all tags.
        #|
        grep -oE "[[:blank:]]\+[[:alnum:]]+[[:alnum:]_-]*([[:blank:]]|$)" "$TODO" | tr -d "[:blank:]" | sort -u
        exit 0
        ;;

      -w | --wrap)
        #| **-w**, **--wrap** _N_
        #|     Wrap lines at N characters. Set to 0 to disable line
        #|     wrapping. The default is 72.
        #|
        if ! printf '%s' "$2" | grep -Eq '[[:digit:]]+'; then
          error 1 "Error: Invalid wrap: $2"
        fi
        WRAP="$2"
        shift 2
        ;;

      -A | --no-ansi)
        #| **-A**, **--no-ansi**
        #|     Disable ANSI escape sequences.
        #|
        ANSI='off'
        shift
        ;;

      -H | --no-header)
        #| **-H**, **--no-header**
        #|     Disable printing header.
        #|
        HEADER='off'
        shift
        ;;

      -S | --no-strip)
        #| **-S**, **--no-strip**
        #|     Disable removal of @context keywords in output.
        #|
        STRIP='off'
        shift
        ;;

      -h | --help)
        #| **-h**, **--help**
        #|     Show this help menu.
        #|
        grep -E '^[[:space:]]*#\|.*' "$0" | \
          sed -e 's/^[[:space:]]*#|[[:space:]]//' -e 's/^[[:space:]]*#|$//' | \
          render_ansi | \
          ${PAGER:-cat}
        exit 0
        ;;

      --)
        #| **--**
        #|     End of options.
        #|
        shift
        break
        ;;

      --* | -?)
        error 1 "Error: Unknown option: $1"
        ;;

      -*) # split joined short args
        split="$1"
        shift
        # shellcheck disable=SC2046
        set -- $(printf '%s' "$split" | cut -c 2- | sed 's/./-& /g') "$@"
        continue
        ;;

      *) # end of args
        break
        ;;
    esac
  done
}

  #| ## File Format
  #|
  #| Create a plain text file named `todo.md` to store the todo
  #| tasks. The `todo.md` file can be generated and maintained
  #| using a plain text editor of your choice. The `today` script
  #| looks in the current working directory for a `todo.md` file.
  #| This allows any directory to contain its own set of todos,
  #| which is useful for collaborative (git) projects.
  #|
  #| Each task is on its own line formatted as a markdown list item
  #| with a dash `-` character. Tasks can be given a priority level
  #| using `A-Z` capital characters enclosed within square brackets.
  #| The priority must be the first part of the task and separated
  #| from the task description with a space. Completed tasks contain
  #| a lowercase `x` within the square brackets (or they can just be
  #| deleted if an archive is unnecessary or moved to a done.md
  #| file).
  #|
  #|     - [A] a task with high priority
  #|     - [B] another task but not as urgent
  #|     - [C] do this later
  #|     - [Z] probably never gonna get done
  #|     - [x] completed task
  #|
  #| ### Organize With Tags
  #|
  #| Tasks can also be associated with a project by using the `+`
  #| character followed by any word containing the characters `A-Z`,
  #| `a-z`, `0-9`, or `-`. The word may not begin with a `-`. For
  #| example `+-something` is **not** a valid project. Projects are
  #| useful for grouping tasks and can even be used as an
  #| alternative to task priorities.
  #|
  #|     - [A] write documentation for +myProject
  #|     - [ ] +plan next steps for +myProject
  #|     - [A] do initial research for +nextProject
  #|     - [ ] start new +nextProject
  #|
  #| ### Recurring Tasks & Calendar Events
  #|
  #| There are several built in keywords to assist with describing
  #| recurring tasks and calendar events. These special contexts
  #| are not typically used in conjuntion with prioritized tasks.
  #| Recurring tasks are for things that need to be done at
  #| scheduled intervals while prioritized tasks usually happen just
  #| once. Prioritized tasks also do not have a set time to perform
  #| the task but might contain a due date.
  #|
  #| **NOTE**: any of the keywords described below can use either
  #| an at (`@`) symbol or exclaimation (`!`) prefix. Items that begin
  #| with an `@` are displayed in the task list section of the
  #| output. Items with an `!` prefix are displayed in the reminders
  #| section and if they contain an `@` context keyword it won't be
  #| stripped in the output.
  #|
  #| The included keywords include:
  #|
  #| **@daily**
  #|     tasks that repeat every day
  #|
  #| **@monday**
  #| **@tuesday**
  #| **@wednesday**
  #| **@thursday**
  #| **@friday**
  #| **@saturday**
  #| **@sunday**
  #|     tasks that repeat weekly on a specific day or days if
  #|     multiple keywords are used.
  #|
  #| **@weekday**
  #|     same as @monday @tuesday @wednesday @thursday @friday
  #|
  #| **@weekend**
  #|     same as @saturday @sunday
  #|
  #| **@YEAR-MONTH-DAY**
  #|     one time event
  #|     for example the following are all valid:
  #|
  #|       - @2025-06-14 Dentist Appointment
  #|       - @2025-6-14 Dentist Appointment
  #|       - @2025-June-14 Dentist Appointment
  #|       - @2025-June-14th Dentist Appointment
  #|       - @2025-Jun-14 Dentist Appointment
  #|
  #| **@MONTH-DAY**
  #|     yearly event if day exists
  #|     for example the following are all valid:
  #|
  #|       - @06-14 Pay Domain Name Registration
  #|       - @6-14 Pay Domain Name Registration
  #|       - @June-14 Pay Domain Name Registration
  #|       - @June-14th Pay Domain Name Registration
  #|       - @Jun-14 Pay Domain Name Registration
  #|
  #| **@DAY**
  #|     monthly event if day exists
  #|     for example the following are all valid:
  #|
  #|       - @04 Pay Water Bill
  #|       - @4 Pay Water Bill
  #|       - @4th Pay Water Bill
  #|       - @04th Pay Water Bill
  #|
  #| **@Nth-DAY-of-MONTH**
  #|     yearly event
  #|     for example the following are all valid:
  #|
  #|       - !2nd-Sunday-of-March Daylight Saving Time Begins
  #|       - !1st-Sunday-of-November Daylight Saving Time Ends
  #|       - !2nd-Sun-of-Mar Daylight Saving Time Begins
  #|       - !1st-Sun-of-Nov Daylight Saving Time Ends
  #|       - !last-Monday-of-May Memorial Day
  #|       - !last-mon-of-may Memorial Day
  #|
  #| **@Nth-DAY-of-month**
  #|     monthly event
  #|     for example the following are all valid:
  #|
  #|       - @1st-Saturday-of-month 1 mile swim
  #|       - @4th-sun-of-month 1 mile swim
  #|       - @last-Tue-of-month 1 mile swim
  #|
  #| **@Nth-DAY-of-even-months**
  #| **@Nth-DAY-of-odd-months**
  #|     every other month
  #|     for example the following are all valid:
  #|
  #|       - @3rd-Friday-of-even-months Change filter in pet fountain
  #|       - @2nd-fri-of-odd-months Change filter in pet fountain
  #|       - @last-fri-of-odd-months Change filter in pet fountain
  #|
  #| **@DAY-of-odd-weeks**
  #| **@DAY-of-even-weeks**
  #|     every other week based on week number
  #|     for example:
  #|
  #|       - @tuesday-of-odd-weeks Recycle Paper
  #|       - @tuesday-of-even-weeks Recycle Plastic
  #|
  #| **@easter**
  #|     easter day
  #|     for example:
  #|
  #|       - Easter !easter
  #|
  #| **@N-days-before-easter**
  #| **@N-days-after-easter**
  #|     days before or after easter
  #|     for example:
  #|
  #|       - !47-days-before-easter Mardi Gras
  #|       - !1-day-after-easter Easter Monday
  #|
  #| **@january**
  #| **@february**
  #| **@march**
  #| **@april**
  #| **@may**
  #| **@june**
  #| **@july**
  #| **@august**
  #| **@september**
  #| **@october**
  #| **@november**
  #| **@december**
  #|     task that repeats daily for a month
  #|     for example:
  #|
  #|       - Black History Month !february
  #|       - Go for daily walk @March
  #|
  #| ### Scheduled Tasks
  #|
  #| **HH:MM**
  #|     specific time in 24h format. The time must appear at the
  #|     beginning of the task (ignoring context `@` keywords).
  #|     for example:
  #|
  #|       - @daily 11:30 meal 1
  #|       - @daily 15:30 meal 2
  #|       - @daily 19:30 meal 3
  #|       - @daily 23:30 meal 4
