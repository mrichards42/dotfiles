alias vim=nvim

# Decrypt a .gpg version of a credentials file
function __with_gpg {
  local regex="$1"       # regex to search in args
  local cmd="$2"         # command to execute
  local flag="$3"        # flag that takes a decrypted credentials file
  local creds="$4"       # gpg-encrypted credentials file
  local args=(${@:5})    # other args
  if [[ (-z "$regex" || " $args " =~ " $regex ") && -e "$creds" ]]; then
    local decrypted=$(gpg --batch -q -d "$creds")
    /usr/bin/env "$cmd" $flag <(echo "$decrypted") "${args[@]}"
  else
    /usr/bin/env "$cmd" "${args[@]}"
  fi
}

alias curl='__with_gpg "-n|--netrc" curl --netrc-file ~/.netrc.gpg'
alias papertrail='__with_gpg "" papertrail -c ~/.papertrail.yml.gpg'
alias pt=papertrail
