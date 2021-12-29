## -- jq ----------------------------------------------------------------------

# using fzf as a jq repl
jqrepl() {
  local input;
  if [[ -z "$1" ]]; then
    input=$(cat /dev/stdin)
  else
    input=$(cat "$1")
  fi
  # shellcheck disable=SC2016
  echo '' | input="$input" fzf \
    --disabled \
    --preview-window=down,100 \
    --preview 'printf %s "$input" | jq -C {q}'
}


## -- babashka ----------------------------------------------------------------

# like jq but for edn. Use '%' for each line.
bbq() {
  if [[ "$1" = "-"* ]]; then
    bb -I --stream -e '(def % *input*)' "$@"
  else
    bb -I --stream -e '(def % *input*)' -e "$@"
  fi
}

# jq but through babashka
bbjq() {
  bb -O -e '(json/parsed-seq *in*)' | bbq "$@"
}
