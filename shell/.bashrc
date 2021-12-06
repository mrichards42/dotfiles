# TODO: This belongs in .bash_profile
export PATH="$HOME/.local/bin:$HOME/go/bin:$PATH"
export PATH="/usr/local/opt/binutils/bin:$PATH"

if type nvim &> /dev/null; then
  alias vim=nvim
  export EDITOR=nvim
  export VISUAL=nvim
else
  export EDITOR=vim
  export VISUAL=vim
fi

export HOMEBREW_NO_INSTALL_CLEANUP=1

# TODO: move this to .config or something theme
BASE16_SHELL=$HOME/theme/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# TODO: This also belongs in bash_profile
# support multiple java versions
if which jenv > /dev/null; then eval "$(jenv init -)"; fi

# TODO: remove -n $BASH_VERSION
[[ -n $BASH_VERSION && -f ~/.fzf.bash ]] && source ~/.fzf.bash

# Stack autocompletion
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
eval "$(stack --bash-completion-script stack)"

[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.bashrc.local ] && source ~/.bashrc.local
