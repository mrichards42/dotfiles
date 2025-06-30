" TODO: this seems to get loaded **after** vim-sexp so these settings don't
" actually get applied??? or at least sexp_filetypes doesn't get applied

let g:sexp_filetypes = "lisp,scheme,clojure,fennel"

" This file overrides vim-sexp insert mode mappings
let g:sexp_enable_insert_mode_mappings = 0

function! s:closing_insertion_hack(key) abort
  " A simplified version of sexp#closing_insertion()
  " If we're already on the closing bracket, move right, otherwise insert
  " the closing bracket, without regard for balancing
  let cur = strpart(getline('.'), col('.') - 1, 1)
  if cur ==# a:key
    return "\<C-G>U\<Right>"
  else
    return a:key
  endif
endfunction

function! s:my_sexp_mappings() abort
  if exists('g:sexp_loaded')
    " Override the closing brackets to allow you to enter brackets always (the
    " default jumps to a matching bracket if one is found, which is really
    " weird IMO).
    imap <expr><silent><buffer> )    <SID>closing_insertion_hack(')')
    imap <expr><silent><buffer> ]    <SID>closing_insertion_hack(']')
    imap <expr><silent><buffer> }    <SID>closing_insertion_hack('}')
    " The rest of these are the vim-sexp defaults
    imap <silent><buffer> (    <Plug>(sexp_insert_opening_round)
    imap <silent><buffer> [    <Plug>(sexp_insert_opening_square)
    imap <silent><buffer> {    <Plug>(sexp_insert_opening_curly)
    imap <silent><buffer> "    <Plug>(sexp_insert_double_quote)
    imap <silent><buffer> <BS> <Plug>(sexp_insert_backspace)
  endif
endfunction

augroup sexp_mappings_for_me
  autocmd!
  execute 'autocmd FileType' g:sexp_filetypes 'call s:my_sexp_mappings()'
augroup END
