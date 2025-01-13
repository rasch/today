#!/bin/sh

wrap_line() {
  if test -z "$1" || test "$1" -ne 0; then
    fold -sw "${1:-72}" | sed -E 's/^([^-])/  \1/'
  else
    cat
  fi
}
