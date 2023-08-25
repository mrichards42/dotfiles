## -- basics ------------------------------------------------------------------

export EDITOR=vim
export VISUAL=vim


## -- local tools -------------------------------------------------------------

export PATH="$HOME/.local/bin:$PATH"


## -- homebrew ----------------------------------------------------------------

if [[ -n "$HOMEBREW_REPOSITORY" ]]; then
  export HOMEBREW_NO_ANALYTICS=1
  export HOMEBREW_NO_INSTALL_CLEANUP=1

  # override PATH to prefer some brew "keg only" tools over system
  export PATH="/usr/local/opt/curl/bin:$PATH"
fi

# -- less ---------------------------------------------------------------------

LESS='-iSRFXMx4'

# -- aws ----------------------------------------------------------------------

SAM_CLI_TELEMETRY=0

# -- rtx ----------------------------------------------------------------------

if [[ -z "$RTX_SHELL" ]] && command -v rtx &> /dev/null; then
  source <(rtx activate zsh)
fi
