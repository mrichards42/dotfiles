## -- pbcopy/pbpaste on linux -------------------------------------------------

# From https://github.com/sorin-ionescu/prezto/blob/ecaed1cfa7591d2304d7eb5d69b42b54961a7145/modules/utility/init.zsh#L154-L155
if command -v xclip &> /dev/null; then
  alias pbcopy='xclip -selection clipboard -in'
  alias pbpaste='xclip -selection clipboard -out'
fi


## -- Safe aliases ------------------------------------------------------------

alias cp='cp -i'
alias ln='ln -i'
alias mv='mv -i'
alias rm='rm -i'


## -- Noglob ------------------------------------------------------------------

alias find='noglob find'


## -- Grep --------------------------------------------------------------------

alias ag='ag --no-number'
alias rg='rg --no-line-number'
