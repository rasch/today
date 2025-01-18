#!/bin/sh

generate_date_tokens() {
  y=$(date -d "@$1" "+%Y")                 # year 4-digit
  m=$(date -d "@$1" "+%-m")                # month number without 0 padding
  mm=$(date -d "@$1" "+%m")                # month number 0 padded
  mmm=$(date -d "@$1" "+%b")               # month name 3-char abbreviation
  mmmm=$(date -d "@$1" "+%B")              # month name full
  mn=$(date -d "@$(($1 + 604800))" "+%-m") # month next week
  d=$(date -d "@$1" "+%-d")                # day of month without 0 padding
  dd=$(date -d "@$1" "+%d")                # day of month 0 padded
  w=$(date -d "@$1" "+%a")                 # day of week 3-char abbreviation
  ww=$(date -d "@$1" "+%A")                # day of week name full
  e=$(easter "$y" "$mm" "$dd")             # days before easter (0 is Easter)
  n=$((($(date -d "@$1" '+%-d') - 1) / 7 + 1)) # week number within month
  nn=$(date -d "@$1" "+%-U")               # week number within year

  when="daily|($y-)?(($m|$mm|$mmm|$mmmm)-)?($d|$dd)(st|nd|rd|th)?|$w|$ww|$mmm|$mmmm"

  case "$w" in
    S*) when="$when|weekend" ;;
     *) when="$when|weekday" ;;
  esac

  if test $((m % 2)) -eq 0; then
    when="$when|$n(st|nd|rd|th)-($w|$ww)-of-($mmm|$mmmm|month|even-months)"
  else
    when="$when|$n(st|nd|rd|th)-($w|$ww)-of-($mmm|$mmmm|month|odd-months)"
  fi

  if test "$m" != "$mn"; then
    if test $((m % 2)) -eq 0; then
      when="$when|last-($w|$ww)-of-($mmm|$mmmm|month|even-months)"
    else
      when="$when|last-($w|$ww)-of-($mmm|$mmmm|month|odd-months)"
    fi
  fi

  if test $((nn % 2)) -eq 0; then
    when="$when|($w|$ww)-of-even-weeks"
  else
    when="$when|($w|$ww)-of-odd-weeks"
  fi

  if test "$e" -lt 0; then
    when="$when|$((e * -1))-days?-after-easter"
  elif test "$e" -gt 0; then
    when="$when|$e-days?-before-easter"
  else
    when="$when|easter"
  fi

  printf '%s' "$when"
}
