#!/bin/sh

parse() {
  s=$(($(date -d "${DATE:-$(date +%Y-%m-%d)} 12:00" +%s) + 86400 * ${OFFSET:-0}))

  when="$(generate_date_tokens $s)"
  schedule=$(grep -iE "^-[[:blank:]].*@($when)([[:blank:]]|$)" "$TODO" | strip_keywords)
  reminders="$(grep -iE "^-[[:blank:]].*!($when)([[:blank:]]|$)" "$TODO")"
  time_regex="^-[[:blank:]][012][[:digit:]]:[012345][[:digit:]][[:blank:]]"
  scheduled_tasks="$(printf '%s\n' "$schedule" | grep -Ev "$time_regex")"
  scheduled_time="$(printf '%s\n' "$schedule" | grep -E "$time_regex")"

  if test "$PRIORITY" != 'off'; then
    tasks="$(grep -E "\-[[:blank:]]+\[${PRIORITY:-A}\][[:blank:]]" "$TODO")"
  elif test -n "$TAG"; then
    tasks="$(grep -E "[[:blank:]]\+$TAG([[:blank:]]|$)" "$TODO")"
  fi

  if test "$HEADER" != 'off'; then
    date -d "@$s" '+# %A %B %-d, %Y' | render_ansi
  fi

  if test -n "$scheduled_time"; then
    printf '%s\n' "$scheduled_time" | \
      timesort "$START" | \
      wrap_line "$WRAP" | \
      render_ansi 32
  fi

  if test -n "$scheduled_tasks"; then
    printf '\n%s\n' "$scheduled_tasks" | \
      wrap_line "$WRAP" | \
      render_ansi 37
  fi

  if test -n "$tasks"; then
    printf '\n%s\n' "$tasks" | \
      sed 's/-[[:blank:]]\+\[[A-Z ]\][[:blank:]]/- /' | \
      strip_keywords | \
      wrap_line "$WRAP" | \
      render_ansi 34
  fi

  if test -n "$reminders"; then
    printf '\n%s\n' "$reminders" | \
      strip_keywords '!' | \
      wrap_line "$WRAP" | \
      render_ansi 35
  fi
}
