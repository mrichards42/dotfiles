" Use esc like usual in terminal
tnoremap <Esc> <C-\><C-n>

" Make terminal look more like a terminal
augroup term
  autocmd!
  if has('nvim')
    autocmd TermOpen * setl nonumber | setl modified
  else
    autocmd BufWinEnter * if &buftype == 'terminal' | setl nonumber | setl modified | endif
  endif
augroup END
