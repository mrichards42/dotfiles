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
