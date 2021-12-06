# shellcheck shell=bash
if type nvim &> /dev/null; then alias vim=nvim; fi

__bc() {
  echo "$@" | bc -l
}
alias bc=__bc

alias ag='ag --no-number'

__sum_lines() {
  if [[ -z "$1" ]]; then
    paste -s -d "+" - | \bc
  else
    paste -s -d "+" "$@" | \bc
  fi
}
alias sum-lines=__sum_lines

# Git
alias gd='git diff'
alias gdc='git diff --cached'
alias gco='git checkout'
alias gci='git commit'
alias gca='git commit --amend'
alias gap='git add -p'
alias gpo='git push origin'
alias gs='git status'

# Decrypt a .gpg version of a credentials file
__with_gpg() {
  local regex="$1"       # regex to search in args
  local cmd="$2"         # command to execute
  local flag="$3"        # flag that takes a decrypted credentials file
  local creds="$4"       # gpg-encrypted credentials file
  local args=("${@:5}")    # other args
  if [[ (-z "$regex" || " ${args[*]} " =~ $regex) && -e "$creds" ]]; then
    local decrypted
    decrypted=$(gpg --batch -q -d "$creds")
    /usr/bin/env "$cmd" "$flag" <(echo "$decrypted") "${args[@]}"
  else
    /usr/bin/env "$cmd" "${args[@]}"
  fi
}

alias curl='__with_gpg " -n | --netrc " curl --netrc-file ~/.netrc.gpg'
alias papertrail='__with_gpg "" papertrail -c ~/.papertrail.yml.gpg'
alias pt=papertrail

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



# Babashka functions that work sort of like jq. Use % instead of *input* for
# each line of edn.

# for edn
bbq() {
  if [[ "$1" = "-"* ]]; then
    bb -I --stream -e '(def % *input*)' "$@"
  else
    bb -I --stream -e '(def % *input*)' -e "$@"
  fi
}

# for json
bbjq() {
  bb -O -e '(json/parsed-seq *in*)' | bbq "$@"
}


# stack hack since I can't get linking to work -- run it in the repl
stack-run() {
  # this won't work for spaces of course, but w/e
  local ghci_args=($(echo "$@" | perl -lne '/(.*) -- / && print "$1"'))
  local main_args=($(echo "$@" | perl -pe 's/.* -- //'))
  stack repl "${ghci_args[@]}" <<EOF
:set prompt ""
putStrLn ""
putStrLn "=======================================\r"
putStrLn "${main_args[@]}"
:main ${main_args[@]}
putStrLn "=======================================\r"
:quit
EOF
}

# Again, can't get linking to work, so here's a crappy doctest

_stack_doctest_code() {
  for f in "$@"; do
    if [[ -d "$f" ]]; then
      _stack_doctest_code $(find "$f" -name '*.hs' | sort)
      continue
    fi
    if ! ag -- '--[\s|]*>>>' "$f" > /dev/null; then
      continue
    fi
    perl -0777 -ne 'while (/--\s*\$setup.*\n((?:--\s*>>>.*\n)+)|--[\s|]*>>>\s*(.*)\n--\s*(.*)\s*/g) {
        if ($1) {
          $setup = $1;
          $setup =~ s/^--\s*>>>//mg;
          print "$setup\n";
          next;
        }
        ($a, $e) = ($2, $3);
        if ($a =~ />>|return|<\$>/) {
          # $a =~ s/return/(return . show)/;
          # $e = "(show $e)";
          print ":echo ($a) == $e\n($a) >>= __doctest ($e)\n";
        } else {
          print ":echo ($a) == $e\n__doctest ($e) ($a)\n";
        }
      }' "$f" \
      | cat <(echo ':def! echo \s -> return $ "putStrLn " ++ show s') \
            <(echo ":load $f") \
            <(echo '__doctest a b = if a == b then putStrLn "\\ESC[32mTrue\\ESC[0m" else error $ "\\ESC[31mFAILURE!\\n  expected: " ++ show a ++ "\\n  actual: " ++ show b ++ "\\ESC[0m"') \
            <(echo 'putStrLn "========================================="') \
            <(echo "putStrLn \"$f\"") \
            <(echo 'putStrLn "========================================="') \
            /dev/stdin
  done
}

stack-doctest() {
  _stack_doctest_code "$@" | cat /dev/stdin <(echo ':quit') | stack repl
}


# Run a single cpp file as if it were a script

cpp-run() {
  local exec_str
  local includes="cstdio iostream vector string cmath"
  while true; do
    case "$1" in
        -e)
            exec_str="$2"
            shift; shift
            ;;
        -i)
            includes="$includes $2"
            shift; shift
            ;;
        *)
            break
            ;;
    esac
  done
  if [[ -n "$exec_str" ]]; then
    # shellcheck disable=SC2086 # word splitting intentional
    includes=$(echo "$includes" | perl -pe 's/ +|,/\n/g' | xargs -I {} printf '#include <%s>\n' {})
    exec_str=$(printf '%s\nusing namespace std;\nint main(int argc, char **argv) {\n%s;\n}\n' "$includes" "$exec_str")
    printf '%s\n' "$exec_str"
    printf '%s\n' "$exec_str" | cpp-run /dev/stdin "$@"
  elif [[ -n "$1" ]]; then
    # normal case -- just run the script
    local cpp="$1"
    shift
    g++ -O2 -xc++ --std=c++17 -o "${o=$(mktemp)}" "$cpp" && echo "$cpp -> $o" && "$o" "$@"
  else
    echo "Expected either a filename or -e ''"
    exit 1
  fi
}
