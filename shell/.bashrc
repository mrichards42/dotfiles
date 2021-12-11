[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.bashrc.local ] && source ~/.bashrc.local

[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
