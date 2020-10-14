" Indentation {{{

" Shorter search distance for clojure indent (breaks really long forms, but is
" a huge speed boost)
let g:clojure_maxlines=75

" Extra syntax highlighting
let g:clojure_syntax_keywords = {
    \ 'clojureMacro': ["defproject", "defstate"],
    \ }

" Standard indentation
let g:clojure_align_subforms=1
let g:clojure_fuzzy_indent=1

" Special indentation forms
let defaults = ['^with', '^def', '^let']
let language_features = ['cond', 'comment', '^do$', '^try', '^finally']
let spec = ['^fdef']
let core_async = ['^go']
let core_match = ['match']
let cljs_test = ['use-fixtures']
let re_frame = ['^fn-traced']
let g:clojure_fuzzy_indent_patterns=
      \ defaults + language_features +
      \ spec + core_async + core_match + cljs_test + re_frame

" default ['-fn$', '\v^with-%(meta|out-str|loading-context)$']
let g:clojure_fuzzy_indent_blacklist = []

" Even better -- use zprint

let g:zprint_path = globpath('~/.local/bin', 'zprint*')
if executable(g:zprint_path)
  let trim_whitespace = "sed -E 's/ +$//g'"

  let &l:equalprg = g:zprint_path . " '{:style :indent-only}' | " . trim_whitespace

  " Command to zprint a range, with options
  command! -range=% -nargs=? ZP :execute '<line1>,<line2>! ' . g:zprint_path . ' ' . <q-args> . " | " . trim_whitespace

  " zprint only works on top-level forms, so make the default indentation
  " target a top-level form
  let g:sexp_mappings = {'sexp_indent': ''}
  nmap <buffer><silent> == =aF
endif



" }}}


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

command! -bang -nargs=? REPL call s:start_repl(<bang>0, <q-args>)
command! -nargs=? NS call s:set_repl_ns(<q-args>)
nmap <buffer> <Leader>in :NS<CR>
nmap <buffer> cr <Plug>(neoterm-repl-send)
nmap <buffer> crr craf

" These functions require the neoterm plugin

function! s:set_repl_ns(ns)
  if a:ns != ''
    let ns_form = '(ns ' . a:ns . ')'
  else
    " find the current ns and switch into it
    let ns_form = matchstr(getline(0, 10), '\v\(ns\s+\S+')
    let ns_form = ns_form == '' ? '(ns user)' : ns_form . ')'
  endif
  call g:neoterm.repl.exec([ns_form])
endfunction

function! s:start_repl(restart, profile)
  " clean up any existing repl
  if a:restart && has_key(g:neoterm.repl, 'instance_id')
    let inst = g:neoterm.repl.instance()
    call neoterm#close({'target': g:neoterm.repl.instance_id, 'force': 1})
    " I think this isn't called until the actual process is closed, but we can
    " force it here
    call inst.on_exit()
  endif
  if a:profile != ''
    call neoterm#repl#set('lein with-profile ' . a:profile . ' repl')
  endif
  " this will start a new repl if none exists
  call s:set_repl_ns('')
endfunction

" ClojureScript REPL
command! Figwheel :execute "Piggieback (do (require 'figwheel-sidecar.repl-api) (figwheel-sidecar.repl-api/repl-env))" | echo 'Connected to Figwheel!'

" }}}
