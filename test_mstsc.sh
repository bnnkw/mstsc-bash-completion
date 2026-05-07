#!/bin/bash

set -u

source ./mstsc

pass=0
fail=0

run()
{
  local line="$1"
  read -ra COMP_WORDS <<< "$line"
  [[ "$line" == *" " ]] && COMP_WORDS+=("")
  COMP_CWORD=$((${#COMP_WORDS[@]} - 1))
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

echo
echo "PASS=$pass FAIL=$fail"
exit $(( fail > 0 ))
