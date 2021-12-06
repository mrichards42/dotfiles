" 100% taken from my clojure file -- should figure out how to share that


let g:fennel_align_subforms = 1

" Use only some of the sexp insert mappings
let g:sexp_enable_insert_mode_mappings = 0

function! ClosingInsertionHack(key)
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

" c/p from vim-sexp of the insert mappings I want
imap <silent><buffer> (    <Plug>(sexp_insert_opening_round)
imap <silent><buffer> [    <Plug>(sexp_insert_opening_square)
imap <silent><buffer> {    <Plug>(sexp_insert_opening_curly)
imap <expr><silent><buffer> )    ClosingInsertionHack(')')
imap <expr><silent><buffer> ]    ClosingInsertionHack(']')
imap <expr><silent><buffer> }    ClosingInsertionHack('}')
imap <silent><buffer> "    <Plug>(sexp_insert_double_quote)
imap <silent><buffer> <BS> <Plug>(sexp_insert_backspace)


nmap <buffer> cr <Plug>(neoterm-repl-send)
nmap <buffer> crr craf
