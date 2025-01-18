#!/bin/sh

timesort() {
  while read -r line; do
    _time="$(printf '%s' "$line" | cut -d ' ' -f 2 | tr -d ':')"

    if test "$_time" -ge "${1:-0430}"; then
      printf '%s\n' "$line"
    else
      printf 'zzz%s\n' "$line"
    fi
  done | sort | sed 's/^zzz//'
}
