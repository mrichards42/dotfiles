" Indentation
let g:fennel_align_subforms = 1
let g:fennel_fuzzy_indent_patterns = [
      \ '^def', '^let', '^while', '^with', '^if', '^fn$', '^var$',
      \ '^case$', '^for$', '^each', '^local$', '^global$', '^match',
      \ '^macro', '^lambda$', '^collect', '^icollect', '^accumulate', '^ns$',
      \ '^comment$']

" Evaluation stuff
function s:evalop(type) abort
  " echo selection#gettext(a:type).code
  exec 'FnlView ' .. selection#gettext(a:type).code
endfunction

function s:compile(text, line1, line2) abort
  if a:text !=# ''
    let expr = a:text
  else
    let expr = join(getline(a:line1, a:line2), "\n")
  endif
  return execute("lua print((require('fennel').compileString([=====[" .. expr .. "]=====])))")
endfunction

function s:jitcompile(text, line1, line2) abort
  let result = s:compile(a:text, a:line1, a:line2)
  return result .. "\n\n" .. system('luajit -bgle ' .. shellescape(result))
endfunction

command -buffer -nargs=? Eval :FnlView <args>
command -buffer -range Compile echo s:compile('', <line1>, <line2>)
command -buffer -range JitCompile echo s:jitcompile('', <line1>, <line2>)

nnoremap <silent><buffer> cp :<C-U>set opfunc=<SID>evalop<CR>g@
xnoremap <silent><buffer> cp :call <SID>evalop(visualmode())<CR>
nmap <silent><buffer> cpp  cpaf
nnoremap <buffer> <Leader>e :Eval 
nnoremap <silent><buffer> <Leader>E :call <SID>evalop('%')<CR>
