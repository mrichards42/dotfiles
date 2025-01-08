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
