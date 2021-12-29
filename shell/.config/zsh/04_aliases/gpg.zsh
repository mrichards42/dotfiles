# Decrypt a .gpg version of a credentials file
-with-gpg() {
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

# `curl -n` uses ~/.netrc.gpg
alias curl='-with-gpg " -n | --netrc " curl --netrc-file ~/.netrc.gpg'

# `papertrail` uses ~/.papertrail.yml.gpg
alias papertrail='--with-gpg "" papertrail -c ~/.papertrail.yml.gpg'
