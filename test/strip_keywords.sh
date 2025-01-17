#!/bin/sh

. src/strip_keywords.sh

diagnostic 'strip_keywords()'

given='- a task @daily'
should='remove @daily keyword from end of task'
actual=$(printf '%s' "$given" | strip_keywords)
expected='- a task'
assert "$given" "$should" "$actual" "$expected"

given='- a @daily task'
should='remove @daily keyword from middle of task'
actual=$(printf '%s' "$given" | strip_keywords)
expected='- a task'
assert "$given" "$should" "$actual" "$expected"

given='- @daily a task'
should='remove @daily keyword from beginning of task'
actual=$(printf '%s' "$given" | strip_keywords)
expected='- a task'
assert "$given" "$should" "$actual" "$expected"

given='- multiple keywords @monday @tuesday @wed @THU @FRIDAY'
should='should remove all keywords from task'
actual=$(printf '%s' "$given" | strip_keywords)
expected='- multiple keywords'
assert "$given" "$should" "$actual" "$expected"

given='- Easter !easter'
should='remove !easter keyword'
actual=$(printf '%s' "$given" | strip_keywords)
expected='- Easter'
assert "$given" "$should" "$actual" "$expected"

given='- @2020-04-20 A task with reminder !2020-04-19'
should='remove only the ! reminder if the ! arg is passed'
actual=$(printf '%s' "$given" | strip_keywords '!')
expected='- @2020-04-20 A task with reminder'
assert "$given" "$should" "$actual" "$expected"

given='- something to do every @monday forever'
should='if STRIP is off, do not remove any text'
actual=$(printf '%s' "$given" | STRIP=off strip_keywords)
expected='- something to do every @monday forever'
assert "$given" "$should" "$actual" "$expected"

given='- days of the week @monday @tuesday @wednesday @thursday @friday @saturday @sunday'
should='should strip all days of the week contexts'
actual=$(printf '%s' "$given" | strip_keywords)
expected='- days of the week'
assert "$given" "$should" "$actual" "$expected"

given='- day of week groups @weekday @weekend'
should='should strip all day of the week group contexts'
actual=$(printf '%s' "$given" | strip_keywords)
expected='- day of week groups'
assert "$given" "$should" "$actual" "$expected"

given='- days of the week @Monday @Tuesday @Wednesday @Thursday @Friday @Saturday @Sunday'
should='should strip all capitalized days of the week contexts'
actual=$(printf '%s' "$given" | strip_keywords)
expected='- days of the week'
assert "$given" "$should" "$actual" "$expected"

given='- days of the week @mon @tue @wed @thu @fri @sat @sun'
should='should strip all abbreviated (3 char) days of the week contexts'
actual=$(printf '%s' "$given" | strip_keywords)
expected='- days of the week'
assert "$given" "$should" "$actual" "$expected"

given='- months of the year @january @february @march @april @may @june @july @august @september @october @november @december'
should='should strip all month contexts'
actual=$(printf '%s' "$given" | strip_keywords)
expected='- months of the year'
assert "$given" "$should" "$actual" "$expected"

given='- months of the year @jan @feb @mar @apr @may @jun @jul @aug @sep @oct @nov @dec'
should='should strip all abbreviated (3 char) month contexts'
actual=$(printf '%s' "$given" | strip_keywords)
expected='- months of the year'
assert "$given" "$should" "$actual" "$expected"

given='- days of every month @01 @02 @03 @04 @1 @2 @3 @4 @20 @1st @2nd @3rd @4th @20th'
should='should strip all contexts'
actual=$(printf '%s' "$given" | strip_keywords)
expected='- days of every month'
assert "$given" "$should" "$actual" "$expected"

given='- specific days @1999-12-31 @1906-12-09 @1906-12-9 @1906-December-9th'
should='should strip all contexts'
actual=$(printf '%s' "$given" | strip_keywords)
expected='- specific days'
assert "$given" "$should" "$actual" "$expected"

given='- yearly tasks and birthdays @12-31 @06-23 @6-23 @June-23rd @june-23'
should='should strip all contexts'
actual=$(printf '%s' "$given" | strip_keywords)
expected='- yearly tasks and birthdays'
assert "$given" "$should" "$actual" "$expected"

given='- specific week and day of specific month @1st-tue-of-jan @2nd-Tue-of-Jan @3rd-tuesday-of-january @4th-Tuesday-of-January @1st-Mon-of-month @last-Friday-of-even-months @last-wednesday-of-odd-months'
should='should strip all contexts'
actual=$(printf '%s' "$given" | strip_keywords)
expected='- specific week and day of specific month'
assert "$given" "$should" "$actual" "$expected"

given='- specific day biweekly @Tue-of-odd-weeks @Tuesday-of-even-weeks @tue-of-even-weeks @tuesday-of-odd-weeks'
should='should strip all contexts'
actual=$(printf '%s' "$given" | strip_keywords)
expected='- specific day biweekly'
assert "$given" "$should" "$actual" "$expected"

given='- days before or after Easter @46-days-before-Easter @2-days-before-Easter @47-days-before-Easter @3-days-after-easter @25-days-after-easter'
should='should strip all contexts'
actual=$(printf '%s' "$given" | strip_keywords)
expected='- days before or after Easter'
assert "$given" "$should" "$actual" "$expected"
