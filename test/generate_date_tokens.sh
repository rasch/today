#!/bin/sh

. src/generate_date_tokens.sh

diagnostic 'generate_date_tokens()'

given='1745035200 (1 day before easter 2025)'
should='return date tokens for 2025-04-19'
actual=$(generate_date_tokens 1745035200)
expected='daily|(2025-)?((4|04|Apr|April)-)?(19|19)(st|nd|rd|th)?|Sat|Saturday|Apr|April|weekend|3(st|nd|rd|th)-(Sat|Saturday)-of-(Apr|April|month|even-months)|(Sat|Saturday)-of-odd-weeks|1-days?-before-easter'

assert "$given" "$should" "$actual" "$expected"

given='1745121600 (easter 2025)'
should='return date tokens for 2025-04-20'
actual=$(generate_date_tokens 1745121600)
expected='daily|(2025-)?((4|04|Apr|April)-)?(20|20)(st|nd|rd|th)?|Sun|Sunday|Apr|April|weekend|3(st|nd|rd|th)-(Sun|Sunday)-of-(Apr|April|month|even-months)|(Sun|Sunday)-of-even-weeks|easter'

assert "$given" "$should" "$actual" "$expected"

given='1745208000 (1 day after easter 2025)'
should='return date tokens for 2025-04-21'
actual=$(generate_date_tokens 1745208000)
expected='daily|(2025-)?((4|04|Apr|April)-)?(21|21)(st|nd|rd|th)?|Mon|Monday|Apr|April|weekday|3(st|nd|rd|th)-(Mon|Monday)-of-(Apr|April|month|even-months)|(Mon|Monday)-of-even-weeks|1-days?-after-easter'

assert "$given" "$should" "$actual" "$expected"

given='1767157200 (new years eve 2025)'
should='return date tokens for 2025-12-31'
actual=$(generate_date_tokens 1767157200)
expected='daily|(2025-)?((12|12|Dec|December)-)?(31|31)(st|nd|rd|th)?|Wed|Wednesday|Dec|December|weekday|5(st|nd|rd|th)-(Wed|Wednesday)-of-(Dec|December|month|even-months)|last-(Wed|Wednesday)-of-(Dec|December|month|even-months)|(Wed|Wednesday)-of-even-weeks|255-days?-after-easter'

assert "$given" "$should" "$actual" "$expected"
