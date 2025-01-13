#!/bin/sh

error() {
  error_code="$1"; shift
  printf '%s\n' "$*" | fold -sw 72 >&2
  exit "$error_code"
}
