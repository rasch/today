#!/bin/sh

render_ansi() {
  if test "$ANSI" = 'off'; then
    cat
  else
    bold=$(printf '\e[1m')
    nobold=$(printf '\e[22m')
    italic=$(printf '\e[3m')
    noitalic=$(printf '\e[23m')
    reverse=$(printf '\e[7m')
    noreverse=$(printf '\e[27m')
    strike=$(printf '\e[9m')
    nostrike=$(printf '\e[29m')
    underline=$(printf '\e[4m')
    nounderline=$(printf '\e[24m')
    nocolor=$(printf '\e[39m')

    sed -E \
      -e "s/\*\*([^*]*)\*\*/$bold\1$nobold/g" \
      -e "s/__([^_]*)__/$bold\1$nobold/g" \
      -e "s/\*([^*]*)\*/$italic\1$noitalic/g" \
      -e "s/([[:blank:]]|^)_([^_]*)_([[:blank:]]|$)/\1$italic\2$noitalic\3/g" \
      -e "s/\`([^\`]*)\`/$reverse \1 $noreverse/g" \
      -e "s/~~([^~]*)~~/$strike\1$nostrike/g" \
      -e "s/^#{1,6}[[:blank:]](.*)$/$underline$bold\1$nounderline$nobold/" \
      -e "s/[[:blank:]](@|!)[^[:blank:]]+/$italic&$noitalic/g" \
      -e "s/[[:blank:]]\+[^[:blank:]]+/$bold&$nobold/g" \
      -e "s/.*/$(printf '\e[%sm' "${1:-39}")&$nocolor/"
  fi
}
