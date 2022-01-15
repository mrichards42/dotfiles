" largely taken from https://github.com/tpope/vim-fireplace/blob/master/autoload/fireplace.vim#L1496
" but without the paren matching bits
function selection#gettext(type) abort
  let sel_save = &selection
  let cb_save = &clipboard
  let reg_save = @@
  try
    set selection=inclusive clipboard-=unnamed clipboard-=unnamedplus
    if a:type ==# '%'      " whole thing?
      silent exe "%y"
    elseif a:type =~# '^.$'    " visual mode
      silent exe "normal! `<" . a:type . "`>y"
    elseif a:type ==# 'line'   " line selection
      silent exe "normal! '[V']y"
    elseif a:type ==# 'block'  " block selection
      silent exe "normal! `[\<C-V>`]y"
    else                       " any other selection(?)
      silent exe "normal! `[v`]y"
    endif
    redraw
    return {'code': @@, 'file': expand('%'), 'line': line("'<"), 'column': col("'<")}
  finally
    let @@ = reg_save
    let &selection = sel_save
    let &clipboard = cb_save
  endtry
endfunction
