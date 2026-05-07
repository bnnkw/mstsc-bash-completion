#!/bin/bash

source /usr/share/bash-completion/bash_completion

set -u

MSTSC_HOME=rdp
source ./mstsc

pass=0
fail=0

run()
{
  local line="$1"
  read -ra COMP_WORDS <<< "$line"
  [[ "$line" == *" " ]] && COMP_WORDS+=("")
  COMP_CWORD=$((${#COMP_WORDS[@]} - 1))
  COMP_LINE="$line"
  COMP_POINT=${#line}
  COMPREPLY=()
  _mstsc
}

assert_eq()
{
  local expected="$1"
  local actual="${COMPREPLY[*]}"
  if [ "$expected" == "$actual" ]; then
    ((pass++))
    echo $'\e[32mOK\e[m'
  else
    ((fail++))
    printf "\e[31mNG\e[m: assert failed '%s' == '%s'\n" "$expected" "$actual"
  fi
}

run 'mstsc.exe /a'
assert_eq '/admin '

run 'mstsc.exe /h'
assert_eq '/h:'

run 'mstsc.exe /p'
assert_eq '/public  /prompt '

win_mstsc_home="$(wslpath -m $MSTSC_HOME)"
run 'mstsc.exe '
assert_eq "$win_mstsc_home/Default2.rdp $win_mstsc_home/Default.rdp"

run "mstsc.exe $win_mstsc_home/Default2"
assert_eq "$win_mstsc_home/Default2.rdp"

echo
echo "PASS=$pass FAIL=$fail"
exit $(( fail > 0 ))
