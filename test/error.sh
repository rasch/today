#!/bin/sh

. src/error.sh

diagnostic 'error()'

given='1 hello world'
should='write "hello world" to stderr and exit 1'
actual=$(eval "error $given" 2>&1)
actual_exit_code=$?
expected='hello world'
expected_exit_code=1

assert "$given" "$should" "$actual" "$expected"
assert "$given" "$should" "$actual_exit_code" "$expected_exit_code"

given='42 bye world'
should='write "bye world" to stderr and exit 42'
actual=$(eval "error $given" 2>&1)
actual_exit_code=$?
expected='bye world'
expected_exit_code=42

assert "$given" "$should" "$actual" "$expected"
assert "$given" "$should" "$actual_exit_code" "$expected_exit_code"

given='0 zero world'
should='write "zero world" to stderr and exit 0'
actual=$(eval "error $given" 2>&1)
actual_exit_code=$?
expected='zero world'
expected_exit_code=0

assert "$given" "$should" "$actual" "$expected"
assert "$given" "$should" "$actual_exit_code" "$expected_exit_code"

given='7 "seven world"'
should='write "seven world" to stderr and exit 7'
actual=$(eval "error $given" 2>&1)
actual_exit_code=$?
expected='seven world'
expected_exit_code=7

assert "$given" "$should" "$actual" "$expected"
assert "$given" "$should" "$actual_exit_code" "$expected_exit_code"
