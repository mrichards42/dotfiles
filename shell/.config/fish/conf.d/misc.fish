## -- telemetry ---------------------------------------------------------------

set -gx DO_NOT_TRACK 1
set -gx TURBO_TELEMETRY_DISABLED 1
set -gx ARTILLERY_DISABLE_TELEMETRY true


## -- misc environment vars ---------------------------------------------------

set -gx BAT_THEME gruvbox-dark


## -- pbcopy/pbpaste on linux -------------------------------------------------

# From https://github.com/sorin-ionescu/prezto/blob/ecaed1cfa7591d2304d7eb5d69b42b54961a7145/modules/utility/init.zsh#L154-L155
if type -q xclip
  alias pbcopy='xclip -selection clipboard -in'
  alias pbpaste='xclip -selection clipboard -out'
end


## -- Safe aliases ------------------------------------------------------------

alias cp='cp -i'
alias ln='ln -i'
alias mv='mv -i'
alias rm='rm -i'

## -- Grep --------------------------------------------------------------------

alias rg='rg --no-line-number'

## -- dos2unix ----------------------------------------------------------------

alias dos2unix='perl -i -p -e \'s|\r\n$|\n|g\''
alias unix2dos='perl -i -p -e \'s|[\r\n]+$|\r\n|g\''
