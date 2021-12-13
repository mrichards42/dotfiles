" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
" source ~/.vimrc

lua package.loaded['bootstrap_fnl'] = nil
lua require('bootstrap_fnl')

command -nargs=+ Fnl :lua print(require('fennel').eval([[ <args> ]]))

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  colorscheme base16-tomorrow-night
  source ~/.vimrc_background   " this is always a base16 colorscheme

  " dimmer highlight colors
  hi Search ctermfg=018 ctermbg=017
  hi WildMenu ctermfg=018 ctermbg=017

  " dimmer matching bracket
  hi MatchParen ctermfg=16 ctermbg=241
else
  colorscheme zenburn
endif
