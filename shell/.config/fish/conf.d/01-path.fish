## Homebrew

set -l brew_cmd $(command -v {/usr/local,/opt/homebrew}/bin/brew)

if test -n "$brew_cmd"
  eval $($brew_cmd shellenv)

  set -gx HOMEBREW_NO_ANALYTICS 1
  set -gx HOMEBREW_NO_INSTALL_CLEANUP 1

  # override PATH to prefer some brew "keg only" tools over system
  fish_add_path "$HOMEBREW_PREFIX/opt/curl/bin"
end

if type -q xcrun
  set -gx SDKROOT (xcrun --show-sdk-path --sdk macosx)
end

## Local scripts

fish_add_path $HOME/.local/bin
