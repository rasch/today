#!/bin/sh

strip_keywords() {
  if test "$STRIP" = 'off'; then
    cat
  else
    _d='(sun|mon|tues|wednes|thurs|fri|satur)day'
    _dd='sun|mon|tue|wed|thu|fri|sat'
    _m='(jan|febr)uary|march|april|may|june|july|august|((sept|nov|dec)em|octo)ber'
    _mm='jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec'

    _k="daily|weekday|weekend|easter|$_d|$_dd|$_m|$_mm"
    _k="$_k|([[:digit:]]{4}-)?(($_m|$_mm|[[:digit:]]{1,2})-)?([[:digit:]]{1,2})(st|nd|rd|th)?"
    _k="$_k|([[:digit:]](st|nd|rd|th)|last)-($_d|$_dd)-of-($_m|$_mm|month|(even|odd)-months)"
    _k="$_k|($_d|$_dd)-of-(odd|even)-weeks"
    _k="$_k|[[:digit:]]+-days?-(before|after)-easter"

    sed -E "s/[[:blank:]](${1:-@|!})($_k)//gi"
  fi
}
