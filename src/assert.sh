#!/bin/sh

trap '_summary' EXIT

printf 'TAP version 13\n'

# _summary :: Null -> String
_summary() {
  printf '\n1..%s\n# tests %s\n# pass  %s\n# fail  %s\n' \
    "$_total" "${_total:-0}" $((_total - _failed)) "${_failed:-0}"

  test -n "$_bailed" && exit 1

  exit "${_failed:-0}"
}

# assert :: (String, String, a, b) -> String
assert() {
  _total=$((_total + 1))

  if test "$3" = "$4"; then
    printf 'ok %s given %s: should %s\n' "$_total" "$1" "$2"
  else
    _failed=$((_failed + 1))

    printf 'not ok %s given %s: should %s
    ---
    got: %s
    expected: %s
    ...\n' "$_total" "$1" "$2" "$3" "$4"

    return 1
  fi
}

# bail :: String -> String
bail() {
  _bailed=true
  printf 'Bail out! %s\n' "$*"
  exit
}

# diagnostic :: String -> String
diagnostic() {
  printf '# %s\n' "$*"
}
