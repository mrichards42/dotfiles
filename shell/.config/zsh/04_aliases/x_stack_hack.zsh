# Hacks for running Haskell without compiling (using ghci) that I used in 2020
# when I was having linker errors (on mac).

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

-stack-doctest-code() {
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
  -stack-doctest-code "$@" | cat /dev/stdin <(echo ':quit') | stack repl
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
    >&2 printf '%s\n' "$exec_str"
    printf '%s\n' "$exec_str" | cpp-run /dev/stdin "$@"
  elif [[ -n "$1" ]]; then
    # normal case -- just run the script
    local cpp="$1"
    shift
    g++ -O2 -xc++ --std=c++17 -o "${o=$(mktemp)}" "$cpp" \
      && >&2 echo "$cpp -> $o" \
      && "$o" "$@"
  else
    echo "Expected either a filename or -e ''"
    return 0
  fi
}
