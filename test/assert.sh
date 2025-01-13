#!/bin/sh

diagnostic 'assert.sh diagnostic()'

given='a string as single arg'
should='return string as TAP diagnostic'
actual=$(diagnostic 'Hello world')
expected='# Hello world'

assert "$given" "$should" "$actual" "$expected"

given='a string as multiple args'
should='return string as TAP diagnostic'
actual=$(diagnostic Hello world)
expected='# Hello world'

assert "$given" "$should" "$actual" "$expected"

given='a string with punctuation'
should='return string as TAP diagnostic'
actual=$(diagnostic '#! Hello <+&,&+> world !#')
expected='# #! Hello <+&,&+> world !#'

assert "$given" "$should" "$actual" "$expected"

diagnostic 'assert.sh bail()'

given='a string as multile args'
should='halt tests with given string as message'
actual=$(bail Error message goes here)
expected='Bail out! Error message goes here'

assert "$given" "$should" "$actual" "$expected"

given='a string as single arg'
should='halt tests with given string as message'
actual=$(bail 'Error message goes here')
exit_code=$?
expected='Bail out! Error message goes here'

assert "$given" "$should" "$actual" "$expected"

given='a string'
should='exit with status 0'
actual="$exit_code"
expected=0

assert "$given" "$should" "$actual" "$expected"

diagnostic 'assert.sh assert()'

given='two identical strings'
should='return ok'
actual=$(_total=41 assert given should hello hello)
expected='ok 42 given given: should should'

assert "$given" "$should" "$actual" "$expected"

given='two different strings'
should='return not ok'
actual=$(_total=0 assert given should hello world)
expected='not ok 1 given given: should should
    ---
    got: hello
    expected: world
    ...'

assert "$given" "$should" "$actual" "$expected"

given='two equal integers'
should='return ok'
actual=$(_total=0 assert "two equal integers" "return ok" $((3 * 3)) 9)
expected='ok 1 given two equal integers: should return ok'

assert "$given" "$should" "$actual" "$expected"

diagnostic 'assert.sh _summary()'

given='12 tests with 3 failed'
should='return summary'
actual=$(_total=12 _failed=3 _summary)
actual_exit_code=$?
expected=$(printf '\n1..12\n# tests 12\n# pass  9\n# fail  3')
expected_exit_code=3

assert "$given" "$should" "$actual" "$expected"
assert "$given" "$should" "$actual_exit_code" "$expected_exit_code"

given='1 test with 1 failed'
should='return summary and exit code 1'
actual=$(_total=1 _failed=1 _summary)
actual_exit_code=$?
expected=$(printf '\n1..1\n# tests 1\n# pass  0\n# fail  1')
expected_exit_code=1

assert "$given" "$should" "$actual" "$expected"
assert "$given" "$should" "$actual_exit_code" "$expected_exit_code"

given='unset _total and unset _failed'
should='return summary'
actual=$(_total='' _failed='' _summary)
actual_exit_code=$?
expected=$(printf '\n1..\n# tests 0\n# pass  0\n# fail  0')
expected_exit_code=0

assert "$given" "$should" "$actual" "$expected"
assert "$given" "$should" "$actual_exit_code" "$expected_exit_code"
