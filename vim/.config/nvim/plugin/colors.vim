" Use only undercurl for spelling instead of bg/fg colors
function! s:SpellColors()
  highlight clear SpellBad   | highlight SpellBad cterm=undercurl gui=undercurl
  highlight clear SpellCap
  highlight clear SpellLocal | highlight SpellLocal cterm=undercurl gui=undercurl
  highlight clear SpellRare  | highlight SpellRare cterm=undercurl gui=undercurl
endfunction

" Make the status line pop in insert mode
let s:status_bg = "NONE"

function! s:InsertHighlight()
  let s:status_bg = synIDattr(synIDtrans(hlID("StatusLine")), "bg", "gui")
  highlight StatusLine guibg=#3f495e
endfunction

function! s:InsertReset()
  if s:status_bg == ""
    highlight StatusLine guibg=NONE
  else
    exec "highlight StatusLine guibg=" .. s:status_bg
  endif
endfunction

" Apply the above functions
augroup colors
  autocmd!
  autocmd ColorScheme * call s:SpellColors()
  autocmd InsertEnter * call s:InsertHighlight()
  autocmd InsertLeave * call s:InsertReset()
augroup END

" Trigger the ColorScheme command if we've already set the colorscheme, since
" otherwise the above tweaks would be ignored
if get(g:, "colors_name", "") != ""
  exec "doautoall colors ColorScheme " .. g:colors_name
endif
