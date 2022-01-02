" Use only undercurl for spelling instead of bg/fg colors
function! s:SpellColors()
  highlight clear SpellBad   | highlight SpellBad cterm=undercurl gui=undercurl
  highlight clear SpellCap
  highlight clear SpellLocal | highlight SpellLocal cterm=undercurl gui=undercurl
  highlight clear SpellRare  | highlight SpellRare cterm=undercurl gui=undercurl
endfunction

function! s:GruvboxMaterialOverride()
  " Tweaking diff colors. These are a mix of the background and red/green/blue
  " colors in the material/hard palette. And most importantly DiffText is
  " muted, instead of the very bright blue default.
  " https://colordesigner.io/color-mixer/?mode=lab#1D2021%7B12%7D-A9B665%7B0%7D-7DAEA3%7B2%7D-EA6962%7B0%7D
  highlight DiffChange guibg=#2a3231
  highlight DiffText guifg=NONE guibg=#3b4b49
  highlight DiffAdd guibg=#3d4132
  highlight DiffDelete guibg=#4d3330
  " Tweaking line number colors (this is the same as SignColumn/CursorLine)
  highlight LineNr guibg=#282828
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
  autocmd ColorScheme gruvbox-material call s:GruvboxMaterialOverride()
  autocmd ColorScheme * call s:SpellColors()
  autocmd InsertEnter * call s:InsertHighlight()
  autocmd InsertLeave * call s:InsertReset()
augroup END

" Trigger the ColorScheme commands if we've already set the colorscheme, since
" otherwise the above tweaks would be ignored
if get(g:, "colors_name", "") != ""
  exec "doautoall colors ColorScheme " .. g:colors_name
endif
