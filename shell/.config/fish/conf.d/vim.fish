set -gx EDITOR nvim
set -gx VISUAL nvim

if type -q nvim
  alias vim=nvim
  alias vimdiff='nvim -d'
end

# cute
alias :e=vim
alias :q=exit
alias :qa=exit
alias :qa!=exit
alias :vsp='tmux split-window -h'
alias :vsplit='tmux split-window -h'
alias :sp='tmux split-window -v'
alias :split='tmux split-window -v'
