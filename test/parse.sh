#!/bin/sh

. src/render_ansi.sh
. src/strip_keywords.sh
. src/timesort.sh
. src/wrap_line.sh
. src/parse.sh

diagnostic 'parse()'

# -----

given='ANSI=off TODO=example/todo.md DATE=2025-04-19'
should='parse todo file and print without ANSI escape sequences'
actual=$(ANSI=off TODO=example/todo.md DATE=2025-04-19 parse)
expected="$(cat <<'EOF'
# Saturday April 19, 2025
- 07:30 wake up
- 08:00 meal 1 (also take vitamins)
- 08:30 work
- 10:00 mobility limber 11 and walk
- 11:30 shower and grooming
- 12:00 meal 2
- 12:30 work
- 13:50 dentist appointment
- 16:00 meal 3
- 16:30 work
- 20:00 meal 4
- 20:30 work
- 23:30 get ready for bed (listen to audiobook)
- 00:00 bed

- fix bug in +project
- update docs for +project
EOF
)"

assert "$given" "$should" "$actual" "$expected"

# -----

given='ANSI=off TODO=example/todo.md DATE=2025-01-01'
should='parsed todo file should contain "- New Year'\''s Day"'
parsed=$(ANSI=off TODO=example/todo.md DATE=2025-01-01 parse)
actual="$(printf '%s\n' "$parsed" | grep -E "^- New Year's Day$")"
expected="- New Year's Day"

assert "$given" "$should" "$actual" "$expected"

# -----

given='ANSI=off TODO=example/todo.md DATE=2025-01-20'
should='parsed todo file should contain "- Martin Luther King Jr. Day"'
parsed=$(ANSI=off TODO=example/todo.md DATE=2025-01-20 parse)
actual="$(printf '%s\n' "$parsed" | grep -E "^- Martin Luther King Jr. Day$")"
expected="- Martin Luther King Jr. Day"

assert "$given" "$should" "$actual" "$expected"

# -----

given='ANSI=off TODO=example/todo.md DATE=2025-04-20'
should='parsed todo file should contain "- Easter"'
parsed=$(ANSI=off TODO=example/todo.md DATE=2025-04-20 parse)
actual="$(printf '%s\n' "$parsed" | grep -E '^- Easter$')"
expected='- Easter'

assert "$given" "$should" "$actual" "$expected"

# -----

given='ANSI=off TODO=example/todo.md DATE=2025-05-26'
should='parsed todo file should contain "- Memorial Day"'
parsed=$(ANSI=off TODO=example/todo.md DATE=2025-05-26 parse)
actual="$(printf '%s\n' "$parsed" | grep -E '^- Memorial Day$')"
expected='- Memorial Day'

assert "$given" "$should" "$actual" "$expected"

# -----

given='ANSI=off TODO=example/todo.md DATE=2025-06-19'
should='parsed todo file should contain "- Juneteenth"'
parsed=$(ANSI=off TODO=example/todo.md DATE=2025-06-19 parse)
actual="$(printf '%s\n' "$parsed" | grep -E '^- Juneteenth$')"
expected='- Juneteenth'

assert "$given" "$should" "$actual" "$expected"

# -----

given='ANSI=off TODO=example/todo.md DATE=2025-07-04'
should='parsed todo file should contain "- Independence Day"'
parsed=$(ANSI=off TODO=example/todo.md DATE=2025-07-04 parse)
actual="$(printf '%s\n' "$parsed" | grep -E '^- Independence Day$')"
expected='- Independence Day'

assert "$given" "$should" "$actual" "$expected"

# -----

given='ANSI=off TODO=example/todo.md DATE=2025-09-01'
should='parsed todo file should contain "- Labor Day"'
parsed=$(ANSI=off TODO=example/todo.md DATE=2025-09-01 parse)
actual="$(printf '%s\n' "$parsed" | grep -E '^- Labor Day$')"
expected='- Labor Day'

assert "$given" "$should" "$actual" "$expected"

# -----

given='ANSI=off TODO=example/todo.md DATE=2025-11-11'
should='parsed todo file should contain "- Veterans Day"'
parsed=$(ANSI=off TODO=example/todo.md DATE=2025-11-11 parse)
actual="$(printf '%s\n' "$parsed" | grep -E '^- Veterans Day$')"
expected='- Veterans Day'

assert "$given" "$should" "$actual" "$expected"

# -----

given='ANSI=off TODO=example/todo.md DATE=2025-11-27'
should='parsed todo file should contain "- Thanksgiving"'
parsed=$(ANSI=off TODO=example/todo.md DATE=2025-11-27 parse)
actual="$(printf '%s\n' "$parsed" | grep -E '^- Thanksgiving$')"
expected='- Thanksgiving'

assert "$given" "$should" "$actual" "$expected"

# -----

given='ANSI=off TODO=example/todo.md DATE=2025-12-25'
should='parsed todo file should contain "- Christmas"'
parsed=$(ANSI=off TODO=example/todo.md DATE=2025-12-25 parse)
actual="$(printf '%s\n' "$parsed" | grep -E '^- Christmas$')"
expected='- Christmas'

assert "$given" "$should" "$actual" "$expected"

# -----

given='ANSI=off TODO=example/todo.md DATE=2025-05-28 PRIORITY=B'
should='parsed todo file should contain "- add CI to +project and publish package"'
actual=$(ANSI=off TODO=example/todo.md DATE=2025-05-28 PRIORITY=B parse)
expected="$(cat <<'EOF'
# Wednesday May 28, 2025
- 07:30 wake up
- 08:00 meal 1 (also take vitamins)
- 08:30 work
- 10:00 strength train (protein shake) and walk
- 11:30 shower and grooming
- 12:00 meal 2
- 12:30 work
- 16:00 meal 3
- 16:30 work
- 20:00 meal 4
- 20:30 work
- 23:30 get ready for bed (listen to audiobook)
- 00:00 bed

- add CI to +project and publish package
EOF
)"

assert "$given" "$should" "$actual" "$expected"

# -----

given='ANSI=off TODO=example/todo.md DATE=2025-10-31 PRIORITY=off TAG=topic'
should='parsed todo file should contain all tasks with the +topic tag'
actual=$(ANSI=off TODO=example/todo.md DATE=2025-10-31 PRIORITY=off TAG=topic parse)
expected="$(cat <<'EOF'
# Friday October 31, 2025
- 07:30 wake up
- 08:00 meal 1 (also take vitamins)
- 08:30 work
- 10:00 strength train (protein shake) and walk
- 11:30 shower and grooming
- 12:00 meal 2
- 12:30 work
- 16:00 meal 3
- 16:30 work
- 20:00 meal 4
- 20:30 work
- 23:30 get ready for bed (listen to audiobook)
- 00:00 bed

- pay internet +bill

- write +blog post about +topic
- proofread +blog post about +topic

- Halloween
EOF
)"

assert "$given" "$should" "$actual" "$expected"
