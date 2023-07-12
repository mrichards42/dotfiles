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


# -- asdf ---------------------------------------------------------------------

if [[ -f "$HOME/.asdf/asdf.sh" ]]; then
  . $HOME/.asdf/asdf.sh
  fpath=(${ASDF_DIR}/completions $fpath)
fi

if [[ -f "$HOME/.asdf/plugins/java/set-java-home.zsh" ]]; then
  . "$HOME/.asdf/plugins/java/set-java-home.zsh"
fi

# -- less ---------------------------------------------------------------------

LESS='-iSRFXMx4'

# -- aws ----------------------------------------------------------------------

SAM_CLI_TELEMETRY=0
