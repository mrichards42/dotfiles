# use instead of git for managing dotfiles
alias dotfiles='/usr/bin/env git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.bashrc.local ] && source ~/.bashrc.local
