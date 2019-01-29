" Shorter search distance for clojure indent (breaks really long forms, but is
" a huge speed boost)
let g:clojure_maxlines=75

" Standard indentation
let g:clojure_align_subforms=1
let g:clojure_fuzzy_indent=1
" default: ['^with', '^def', '^let']
let g:clojure_fuzzy_indent_patterns=['^with', '^def', '^let', '^try', '^finally', 'fdef', 'cond', 'comment', 'do', 'match', '^go']
" default ['-fn$', '\v^with-%(meta|out-str|loading-context)$']
let g:clojure_fuzzy_indent_blacklist = []

" Mappings {{{

" Open repl command line
nmap <buffer> <Leader>e :Eval 
" Eval current buffer
nmap <buffer> <Leader>E :%Eval<CR>
" gd instead of [<C-D> to jump to definition
nmap <buffer> gd <Plug>FireplaceDjump

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

" }}}

" REPL {{{

" ClojureScript REPL
command! Figwheel :execute "Piggieback (do (require 'figwheel-sidecar.repl-api) (figwheel-sidecar.repl-api/repl-env))" | echo 'Connected to Figwheel!'

" }}}
