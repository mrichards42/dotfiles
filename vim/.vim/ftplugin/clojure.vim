let b:ale_linters = ['clj-kondo']

" Indentation {{{

" Extra syntax highlighting
let g:clojure_syntax_keywords = {
    \ 'clojureMacro': ["defproject", "defstate"],
    \ }

" Standard indentation
let g:clojure_align_subforms=1
let g:clojure_fuzzy_indent=1

" Special indentation forms
let defaults = ['^with', '^def', '^let']
let language_features = ['cond', 'comment', '^do$', '^try', '^finally', 'delay']
let spec = ['^fdef']
let core_async = ['^go']
let core_match = ['match']
let cljs_test = ['use-fixtures']
let re_frame = ['^fn-traced']
let test_chuck = ['checking']
let g:clojure_fuzzy_indent_patterns=
      \ defaults + language_features +
      \ spec + core_async + core_match + cljs_test + re_frame + test_chuck

" default ['-fn$', '\v^with-%(meta|out-str|loading-context)$']
let g:clojure_fuzzy_indent_blacklist = []

" Even better -- use zprint

let g:zprint_path = globpath('~/.local/bin', 'zprint*')
if executable(g:zprint_path) && 0
  let trim_whitespace = "sed -E 's/ +$//g'"

  let &l:equalprg = g:zprint_path . " '{:style :indent-only}' | " . trim_whitespace

  " Command to zprint a range, with options
  command! -range=% -nargs=? ZP :execute '<line1>,<line2>! ' . g:zprint_path . ' ' . <q-args> . " | " . trim_whitespace

  " zprint only works on top-level forms, so make the default indentation
  " target a top-level form
  let g:sexp_mappings = {'sexp_indent': ''}
  nmap <buffer><silent> == =aF <c-O>
endif



" }}}


" Mappings {{{

" Open repl command line
nmap <buffer> <Leader>e :Eval 
" Eval current buffer
nmap <buffer> <Leader>E :%Eval<CR>
" gd instead of [<C-D> to jump to definition
nmap <buffer> gd <Plug>FireplaceDjump
" Start and stop mount
nmap <buffer> mrr :Eval (do (mount.core/stop) (mount.core/start))<CR>
" Eval + start and stop mount
nmap <buffer> <Leader>M :%Eval<CR> :Eval (do (mount.core/stop) (mount.core/start))<CR>

command! -nargs=? Dir Eval (clojure.repl/dir <args>)

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
" command! Figwheel :execute "Piggieback (do (require 'figwheel.main.api) (figwheel.main.api/repl-env \"dev\"))" | echo 'Connected to Figwheel!'

" Eval in the REPL (instead of fireplace quasi-repl {{{

" command! -nargs=? EvalREPL call EvalRepl(<q-args>)

" function! EvalRepl(cmd)
"   let bufnr = bufnr('lein')
"   if bufnr > -1
"   endif
"   echo a:cmd
" endfunction


" }}}

" Create a REPL {{{
" Create a repl and connect to it
" command! -bang -nargs=? REPL call CreateRepl(<bang>0, <q-args>)

let s:repl_connect_attempts = 25

function! s:connection_info(...)
  " Return [is_connected, nrepl]
  if a:0 > 0
    let buf_lines = getbufline(a:1, 1, '$')
    " Search for 'nrepl://' in the terminal buffer
    let nrepl = matchstrpos(buf_lines, '\vnrepl://\S+')[0]
    if nrepl == ''
      " Try figwheel
      let port = get(matchlist(buf_lines, '\vStarting nREPL server on port: (\d+)'), 1)
      if port
        let nrepl = 'nrepl://localhost:' . port
      endif
    endif
    return [nrepl != '', nrepl]
  else
    " If we don't have a buffer number, try to fireplace#eval something
    try
      let transport = fireplace#client().connection.transport
      return [1, 'nrepl://' . transport.host . ':' . transport.port]
    catch /\v^Fireplace: :Connect/
    catch /\v^nREPL: .* Connection refused/
    endtry
  endif
  return [0, '']
endfunction

function! s:progress_message(timer)
  try
    let dots = s:repl_connect_attempts - (timer_info(a:timer)[0]['repeat'])
  catch /out of range/
    let dots = s:repl_connect_attempts
  endtry
  return 'Starting a REPL in a hidden terminal buffer' . repeat('.', dots)
endfunction

function! ReplTimer(bufnr, repl_scope, timer)
  let [connected, nrepl] = s:connection_info(a:bufnr)
  if connected
    call timer_stop(a:timer)
    if nrepl != ''
      " Make sure we're actually connected
      exe 'FireplaceConnect ' . nrepl . ' ' . a:repl_scope
      echo 'Connected to ' . nrepl
    else
      " We known we're connected, since we had to use fireplace#eval
      echo s:progress_message(a:timer) . 'Connected!'
    endif
  else
    echo s:progress_message(a:timer) . nrepl
  endif
endfunction

function! s:repl_dir()
  let curdir = getcwd()
  let filedir = expand('%:p:h')
  if stridx(filedir, curdir) ==# 0
    return curdir
  else
    return filedir
  endif
endfunction

function! CreateRepl(force, cmd)
  let default_cmd = expand('%:e') ==? 'cljs' ? 'figwheel' : 'repl'
  if !exists('*fireplace#eval')
    echo 'vim-fireplace is not loaded'
    return
  elseif s:connection_info()[0]
    if a:force
      try
        exe 'bd! lein*' . default_cmd
      catch /More than one/
        echo 'Multiple repl buffers exist'
        return
      catch /No matching/
        " Not a problem
      endtry
    else
      echo 'Already connected to a REPL (add ! to force)'
      return
    endif
  endif
  " Default command is 'lein repl'
  if a:cmd ==# ''
    let cmd = 'lein ' . default_cmd
  elseif a:cmd =~ '\v^+'
    let cmd = 'lein with-profile ' . a:cmd . ' ' . default_cmd
  else
    let cmd = a:cmd
  endif
  " cd to current directory first
  let curdir = s:repl_dir()
  let cmd = "cd '" . curdir . "' && " . cmd
  let bufnr = HiddenTerm(cmd)
  let s:callback = function('ReplTimer', [bufnr, curdir])
  call timer_start(1000, s:callback, {'repeat': s:repl_connect_attempts})
endfunction

" }}}

" }}}
