#!/bin/sh

. src/wrap_line.sh

diagnostic 'wrap_line()'

short_line='- hello world'
long_line="- Architecto non quae dolore omnis quo. Autem nam quo et. \
Quisquam unde sed sint. Error tenetur eius ea voluptatem."

given='one argument 8 and a short line'
should='wrap line at 8 columns'
actual=$(printf '%s' "$short_line" | wrap_line 8)
expected=$(printf -- '- hello \n  world\n')

assert "$given" "$should" "$actual" "$expected"

given='no arguments and a long line'
should='wrap line at 72 columns'
actual=$(printf '%s' "$long_line" | wrap_line)
expected=$(printf -- "- Architecto non quae dolore omnis quo. Autem nam \
quo et. Quisquam unde \n  sed sint. Error tenetur eius ea voluptatem.")

assert "$given" "$should" "$actual" "$expected"

given='one argument 0 and a long line'
should='disable line wrap'
actual=$(printf '%s' "$long_line" | wrap_line 0)
expected="$long_line"

assert "$given" "$should" "$actual" "$expected"

given='one argument 13 the same length of given line'
should='return the line unchanged'
actual=$(printf '%s' "$short_line" | wrap_line 13)
expected="$short_line"

assert "$given" "$should" "$actual" "$expected"

given='one argument 50 and a long line'
should='wrap line at 50 columns'
actual=$(printf '%s' "$long_line" | wrap_line 50)
expected=$(printf -- "- Architecto non quae dolore omnis quo. Autem nam \n\
  quo et. Quisquam unde sed sint. Error tenetur \n  eius ea voluptatem.")

assert "$given" "$should" "$actual" "$expected"
