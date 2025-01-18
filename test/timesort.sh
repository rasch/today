#!/bin/sh

. src/timesort.sh

diagnostic 'timesort()'

tasklist="$(cat <<'EOF'
- 01:33 ninth
- 22:22 fifth
- 11:30 first
- 04:29 eleventh
- 19:00 third
- 23:59 sixth
- 00:00 seventh
- 20:20 fourth
- 13:15 second
- 00:01 eighth
- 03:33 tenth
EOF
)"

given="$tasklist"
should='sort the tasks by time with 04:30 as start of day'
actual=$(printf '%s\n' "$given" | timesort 0430)
expected="$(cat <<'EOF'
- 11:30 first
- 13:15 second
- 19:00 third
- 20:20 fourth
- 22:22 fifth
- 23:59 sixth
- 00:00 seventh
- 00:01 eighth
- 01:33 ninth
- 03:33 tenth
- 04:29 eleventh
EOF
)"

assert "$given" "$should" "$actual" "$expected"

given="$tasklist"
should='sort the tasks by time with 00:00 as start of day'
actual=$(printf '%s\n' "$given" | timesort 0000)
expected="$(cat <<'EOF'
- 00:00 seventh
- 00:01 eighth
- 01:33 ninth
- 03:33 tenth
- 04:29 eleventh
- 11:30 first
- 13:15 second
- 19:00 third
- 20:20 fourth
- 22:22 fifth
- 23:59 sixth
EOF
)"

assert "$given" "$should" "$actual" "$expected"
