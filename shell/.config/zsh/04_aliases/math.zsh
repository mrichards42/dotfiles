# make bc work with either args or stdin
-bc() {
  if [[ -n "$*" ]]; then
    echo "$@" | bc -l
  else
    bc -l
  fi
}
alias bc='noglob -bc'

sum-lines() {
  if [[ -z "$1" ]]; then
    paste -s -d "+" - | bc
  else
    paste -s -d "+" "$@" | bc
  fi
}
