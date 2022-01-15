" Evaluation stuff
function s:evalop(type) abort
  " echo selection#gettext(a:type).code
  exec 'FnlView ' .. selection#gettext(a:type).code
endfunction

command -buffer -nargs=? Eval :FnlView <args>

nnoremap <silent><buffer> cp :<C-U>set opfunc=<SID>evalop<CR>g@
xnoremap <silent><buffer> cp :call <SID>evalop(visualmode())<CR>
nmap <silent><buffer> cpp  cpaf
nnoremap <buffer> <Leader>e :Eval 
nnoremap <silent><buffer> <Leader>E :call <SID>evalop('%')<CR>
