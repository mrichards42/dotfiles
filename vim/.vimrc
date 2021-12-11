
" Basic settings {{{

set nomodeline                         " modelines can execute code
set number                             " line numbers, of course
set nowrap
set encoding=utf-8 fileencoding=utf-8  " always utf-8
set splitright                         " open vsplits to the right
set mouse=a                            " a crutch, but sometimes helpful
if has('mouse_sgr')
  set ttymouse=sgr
endif

filetype plugin indent on              " use all filetype-specific things

" }}}

" Whitespace / Formatting {{{

" Defaults
set expandtab sw=2 ts=2 sts=2          " 2-space tabs
set list lcs=trail:·,nbsp:␣,tab:\>\    " show hidden characters

set textwidth=79 formatoptions-=t      " 79-char lines / don't auto-wrap
set colorcolumn=+1                     " highlight 80th character
set foldmethod=marker

" By filetype
augroup ws
  autocmd!
  autocmd FileType c,cpp,perl,python setl sw=4 ts=4 sts=4
  autocmd FileType vim setl fdm=marker
  autocmd FileType markdown setl wrap linebreak breakindent
  autocmd FileType GV set foldlevel=1
augroup END

" }}}

" Mappings {{{

set timeoutlen=300

" linewise movement over soft wraps
noremap j gj
noremap k gk

" Indent/deinent using tab
imap <Tab> <C-t>
imap <S-Tab> <C-d>
vmap <Tab> > gv
vmap <S-Tab> < gv

" common mistakes
nmap q: :q
nmap Q: :q
cnoreabbrev Q q
cnoreabbrev qA qa
cnoreabbrev QA qa
cnoreabbrev Qa qa

" Handy
cnoreabbrev vsb vertical sbuffer

" easy to hit with either hand
let mapleader = "\<Space>"

" run current file
nmap <Leader>r :!%p

" redraw
nmap <Leader>d :redraw!<CR>

" NERDTree
nmap <Leader>t :NERDTreeToggle<CR>

" ack/ag
if executable('ag')
  let g:ackprg = 'ag --vimgrep --smart-case'
  cnoreabbrev ag Ack!
  cnoreabbrev aG Ack!
  cnoreabbrev Ag Ack!
  cnoreabbrev AG Ack!
endif

" fzf

augroup fzf
  autocmd!
  autocmd FileType fzf tnoremap <buffer> <Esc> <C-c>
augroup END

" Redefine the fzf :Files command to prefer git ls-files if we're in a git
" directory
function! s:fzf_files(bang)
  let dir = split(system('git rev-parse --show-toplevel'), '\n')[0]
  if v:shell_error
    " This is the default fzf command, without excluding hidden files
    " Essentially -- exclude system files, print all others
    let cmd = "bash -c 'set -o pipefail; command "
    \ . "find -L . -mindepth 1 \\( -fstype sysfs -o -fstype devfs -o -fstype devtmpfs -o -fstype proc \\) -prune "
    \ . "-o -type f -print "
    \ . "-o -type l -print "
    \ . "2> /dev/null | cut -b3-'"
  else
    let cmd = "bash -c 'cat <(git ls-files --others --exclude-standard) <(git ls-files) | sort'"
  endif
  return fzf#vim#files(dir || '', {'source': cmd}, a:bang)
endfunction

command! -bang -nargs=0 -complete=dir Files call s:fzf_files(<bang>0)

nmap <Leader>ff :Files<CR>
nmap <Leader>fl :Lines<CR>
nmap <Leader>f/ :BLines<CR>
nmap <Leader>fb :Buffers<CR>

" }}}

" Search {{{

set incsearch            " incremental search
set ignorecase smartcase " ignore case unless term has an uppercase char

" highlight all search terms / Leader-h removes highlight
set hlsearch
map <Leader>h :noh<CR>

" }}}

" Plugins {{{

" To install vim-plug
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.vim/plugged')
  " Language packs
  let g:polyglot_disabled = ['markdown', 'pgsql']
  Plug 'sheerun/vim-polyglot'
  Plug 'lifepillar/pgsql.vim' " More up to date than polyglot

  " Sensible defaults
  Plug 'tpope/vim-sensible'

  " Helpful commands
  Plug 'tpope/vim-eunuch'       " unix commands
  Plug 'tpope/vim-unimpaired'   " square bracked commands
  Plug 'tpope/vim-commentary'   " gcc for toggling comments
  Plug 'tpope/vim-repeat'       " used by multiple plugins for '.' repeating
  Plug 'tpope/vim-rsi'          " readline keys in insert mode
  Plug 'mileszs/ack.vim'        " ack/ag support
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-update-rc' }
  Plug 'junegunn/fzf.vim'       " fuzzy finder

  " Autocomplete
  if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif

  " Theme
  Plug 'chriskempson/base16-vim'

  " Git
  Plug 'tpope/vim-fugitive'
  Plug 'junegunn/gv.vim'
  Plug 'tpope/vim-rhubarb'
  augroup fugitive
    autocmd!
    " Auto-delete fugitive buffers
    autocmd BufReadPost fugitive://* set bufhidden=delete
  augroup END

  " Linting
  Plug 'dense-analysis/ale'

  " File broswer
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

  " Clojure
  Plug 'tpope/vim-fireplace'
  Plug 'tpope/vim-surround'
  Plug 'guns/vim-sexp'
  Plug 'tpope/vim-sexp-mappings-for-regular-people'
  Plug 'clojure-vim/async-clj-omni'

  " Table editing
  Plug 'godlygeek/tabular'

  " Helpful terminal interop
  Plug 'kassio/neoterm'
call plug#end()

" simple markdown tables
command! -nargs=0 MTable :Tabularize /|

" Don't lint temp files
let g:ale_pattern_options = {
\ '\V\^\(' . expand('$TMPDIR') . '\|/tmp\)': {'ale_linters': [], 'ale_fixers': []},
\}

let g:neoterm_default_mod="vertical"   " open terminals in a vsplit
let g:neoterm_autoscroll=1             " scroll terminals after sending text
let g:neoterm_direct_open_repl=1       " don't open an intermediate shell

let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('keyword_patterns', {'clojure': '[\w!$%&*+/:<=>?@\^_~\-\.#]*'})

" }}}

" Syntax {{{

syntax on
set t_Co=256
set synmaxcol=300  " ignore long lines

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background   " this is always a base16 colorscheme

  " dimmer highlight colors
  hi Search ctermfg=018 ctermbg=017
  hi WildMenu ctermfg=018 ctermbg=017

  " dimmer matching bracket
  hi MatchParen ctermfg=16 ctermbg=241
else
  colorscheme zenburn
endif

set spell
" remove background highlighting for spellcheck
hi SpellBad ctermbg=NONE cterm=undercurl
hi SpellCap ctermbg=NONE cterm=undercurl
hi SpellRare ctermbg=NONE cterm=undercurl
hi SpellLocal ctermbg=NONE cterm=undercurl

" dimmer list chars (tab/space)
hi Whitespace ctermfg=241 guifg=#626262

" make insert mode *very* obvious
augroup numbers
  autocmd!
  autocmd InsertEnter * hi LineNr ctermbg=60 guibg=#5f5f87
  autocmd InsertLeave * hi LineNr ctermbg=235 guibg=#262626
augroup END

" highlight current line
augroup CursorLine
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setl cursorline
  autocmd WinLeave * setl nocursorline
augroup END

" Markdown syntax additions
let g:markdown_fenced_languages = ['clj=clojure', 'bash=sh', 'vim']
" let g:vim_markdown_fenced_languages = ['clj=clojure']

" Assume postgresql by default
let g:sql_type_default = 'pgsql'

command! DebugSyntax for id in synstack(line("."), col(".")) | echo synIDattr(id, "name") | endfor

" }}}

" Terminal {{{

" terminal esc
tnoremap <Esc> <C-\><C-n>

" Settings aren't quite the same between vim and nvim
function! SetupTerm()
  setl modified  " this doesn't seem to work in nvim, but whatever
  setl nonumber
endfunction

augroup term
  autocmd!
  if has('nvim')
    autocmd TermOpen * call SetupTerm()
  else
    autocmd BufWinEnter * if &buftype == 'terminal' | call SetupTerm() | endif
  endif
augroup END

" }}}
