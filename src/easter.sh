#!/bin/sh
# https://en.wikipedia.org/wiki/Date_of_Easter#Anonymous_Gregorian_algorithm

# easter :: (Integer, Integer, Integer) -> Integer
# easter :: Integer -> String
easter() {
  a=$(( $1 % 19 ))
  b=$(( $1 / 100 ))
  c=$(( $1 % 100 ))
  h=$(( (19 * a + b - b / 4 - ((8 * b + 13) / 25) + 15) % 30 ))
  l=$(( (32 + 2 * (b % 4) + 2 * (c / 4) - h - c % 4) % 7 ))
  m=$(( (a + 11 * h + 19 * l) / 433 ))
  n=$(( (h + l - 7 * m + 90) / 25 ))
  p=$(( (h + l - 7 * m + 33 * n + 19) % 32 ))

  if test $# = 1; then
    printf '%d-%.2d-%.2d' "$1" "$n" "$p"
  elif test $# = 3; then
    printf '%d' $((
      $(date -d "$1-$n-$p" +%-j)
    - $(date -d "$1-$2-$3" +%-j)
    ))
  fi

  unset a b c h l m n p
}
