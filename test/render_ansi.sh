#!/bin/sh

. src/render_ansi.sh

diagnostic 'render_ansi()'

given='a line with **bold** text'
should='render the bold text'
actual=$(printf '%s' "$given" | render_ansi)
expected=$(printf "\e[39ma line with \e[1mbold\e[22m text\e[39m")

assert "$given" "$should" "$actual" "$expected"

given='a line with __bold__ text'
should='render the bold text'
actual=$(printf '%s' "$given" | render_ansi)
expected=$(printf "\e[39ma line with \e[1mbold\e[22m text\e[39m")

assert "$given" "$should" "$actual" "$expected"

given='a line with _italic_ text'
should='render the italic text'
actual=$(printf '%s' "$given" | render_ansi)
expected=$(printf "\e[39ma line with \e[3mitalic\e[23m text\e[39m")

assert "$given" "$should" "$actual" "$expected"

given='a line with *italic* text and one argument 31'
should='render the text red'
actual=$(printf '%s' "$given" | render_ansi 31)
expected=$(printf "\e[31ma line with \e[3mitalic\e[23m text and one \
argument 31\e[39m")

assert "$given" "$should" "$actual" "$expected"

given='# a heading'
should='remove leading hash and render the text underlined and bold'
actual=$(printf '%s' "$given" | render_ansi)
expected=$(printf "\e[39m\e[4m\e[1ma heading\e[24m\e[22m\e[39m")

assert "$given" "$should" "$actual" "$expected"

given='a line with ~~crossed out~~ text'
should='render the strikethrough text'
actual=$(printf '%s' "$given" | render_ansi)
expected=$(printf "\e[39ma line with \e[9mcrossed out\e[29m text\e[39m")

assert "$given" "$should" "$actual" "$expected"

# shellcheck disable=SC2016
given='a line with `code` text'
should='render the text with reverse escape'
actual=$(printf '%s' "$given" | render_ansi)
expected=$(printf "\e[39ma line with \e[7mcode\e[27m text\e[39m")

assert "$given" "$should" "$actual" "$expected"

given='a line with **bold** text with ansi escapes disabled'
should='render text as given'
actual=$(printf '%s' "$given" | ANSI=off render_ansi)
expected="$given"

assert "$given" "$should" "$actual" "$expected"
