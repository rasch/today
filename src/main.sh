#!/bin/sh

options "$@"

if test -z "$TODO"; then
  if test -f todo.md; then
    TODO='todo.md'
  else
    error 1 "Error: File not found: todo.md"
  fi
fi

parse
