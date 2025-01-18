#!/bin/sh

. src/options.sh

diagnostic 'options()'

# -----

given='--date 2025-04-19'
should='set global variable DATE=2025-04-19'

# shellcheck disable=2086
options $given

actual="$DATE"
expected='2025-04-19'

assert "$given" "$should" "$actual" "$expected"

unset DATE

# -----

given='+1 -d 2025-04-21'
should='set global variables OFFSET=1 DATE=2025-04-21'

# shellcheck disable=2086
options $given

actual="$OFFSET $DATE"
expected='+1 2025-04-21'

assert "$given" "$should" "$actual" "$expected"

unset OFFSET DATE

# -----

given='-d 2024-12-31 -365'
should='set global variables OFFSET=-365 DATE=2024-12-31'

# shellcheck disable=2086
options $given

actual="$OFFSET $DATE"
expected='-365 2024-12-31'

assert "$given" "$should" "$actual" "$expected"

unset OFFSET DATE

# -----

given='-f LICENSE'
should='set global variables TODO=LICENSE'

# shellcheck disable=2086
options $given

actual="$TODO"
expected='LICENSE'

assert "$given" "$should" "$actual" "$expected"

unset TODO

# -----

given='--file doesnotexist.txt'
should='write "Error: File not found: doesnotexist.txt" to stderr and exit 1'
actual=$(eval "options $given" 2>&1)
actual_exit_code=$?
expected='Error: File not found: doesnotexist.txt'
expected_exit_code=1

assert "$given" "$should" "$actual" "$expected"
assert "$given" "$should" "$actual_exit_code" "$expected_exit_code"

# -----

given='--zzz'
should='write "Error: Unknown option: --zzz" to stderr and exit 1'
actual=$(eval "options $given" 2>&1)
actual_exit_code=$?
expected='Error: Unknown option: --zzz'
expected_exit_code=1

assert "$given" "$should" "$actual" "$expected"
assert "$given" "$should" "$actual_exit_code" "$expected_exit_code"
