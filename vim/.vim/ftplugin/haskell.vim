" Indentation {{{

let g:haskell_indent_in = 0

" }}}

" Linting {{{

" COC + the haskell lsp provides a much better experience than ALE's single
" linters, so turn those off
let b:ale_linters = []
let b:ale_enabled = 0

" }}}


" Mappings {{{

command! -nargs=? Eval call g:neoterm.repl.exec([<q-args>])

" Open repl command line
nmap <buffer> <Leader>e :Eval 
" Eval current buffer (same as loading the module)
nmap <buffer> <Leader>E :NS<CR>

" }}}

" REPL {{{

" Adapted from the clojure version

command! -bang REPL call s:start_repl(<bang>0)
command! -nargs=? NS call s:set_repl_ns(<q-args>)
nmap <buffer> <Leader>in :NS<CR>
" nmap <buffer> crr <Plug>(neoterm-repl-send-line)
nmap <buffer> crr :call HaskellEvalLine()<CR>

" These functions require the neoterm plugin

function! HaskellEvalLine()
  let l = getline('.')
  " strip off any doctest prefix
  let doctest_exec = matchlist(l, '\v^--[ |]*\>\>\>\s*(.*)')
  if doctest_exec != []
    let l = doctest_exec[1]
  endif
  call g:neoterm.repl.exec([l])
endfunction

function! s:set_repl_ns(ns)
  if a:ns != ''
    let module_name = a:ns
  else
    let module_name = matchlist(getline(0, 10), '\v^module\s+(\S+)')[1]
  endif
  call g:neoterm.repl.exec([":load " . module_name])
endfunction

function! s:start_repl(restart)
  " clean up any existing repl
  if a:restart && has_key(g:neoterm.repl, 'instance_id')
    let inst = g:neoterm.repl.instance()
    call neoterm#close({'target': g:neoterm.repl.instance_id, 'force': 1})
    " I think this isn't called until the actual process is closed, but we can
    " force it here
    call inst.on_exit()
  endif
  " this will start a new repl if none exists
  call s:set_repl_ns('')
endfunction

" }}}
