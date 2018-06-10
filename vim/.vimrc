
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
set list lcs=trail:*,tab:\>\           " show hidden characters

set textwidth=79 formatoptions-=t      " 79-char lines / don't auto-wrap
set colorcolumn=+1                     " highlight 80th character

" By filetype
augroup ws
  autocmd!
  autocmd FileType c,cpp,perl,python setl sw=4 ts=4 sts=4
  autocmd FileType vim setl fdm=marker
  autocmd FileType markdown setl wrap linebreak breakindent
augroup END

" }}}

" Mappings {{{

" linewise movement over soft wraps
noremap j gj
noremap k gk

" common mistakes
nmap q: :q
nmap Q: :q
cnoreabbrev Q q
cnoreabbrev qA qa
cnoreabbrev QA qa
cnoreabbrev Qa qa

" easy to hit with either hand
let mapleader = "\<Space>"

" run current file
nmap <Leader>r :!%p

" redraw
nmap <Leader>d :redraw!<CR>

" NERDTree
nmap <Leader>t :NERDTreeToggle<CR>

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
  " Sensible defaults
  Plug 'tpope/vim-sensible'

  " Theme
  Plug 'jnurmine/zenburn'

  " Git
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'

  " Linting
  Plug 'w0rp/ale'

  " File broswer
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

  " Clojure
  Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
  Plug 'tpope/vim-surround', { 'for': 'clojure' }
  Plug 'kovisoft/paredit', { 'for': 'clojure' }
call plug#end()

" Don't lint temp files
let g:ale_pattern_options = {
\ '\V\^\(' . expand('$TMPDIR') . '\|/tmp\)': {'ale_linters': [], 'ale_fixers': []},
\}

" }}}

" Syntax {{{

syntax on
set t_Co=256
set synmaxcol=300  " ignore long lines

colorscheme zenburn

" dimmer list chars (tab/space)
hi Whitespace ctermfg=241 guifg=#626262

" make insert mode *very* obvious
augroup numbers
  autocmd!
  autocmd InsertEnter * hi LineNr ctermbg=60 guibg=#5f5f87
  autocmd InsertLeave * hi LineNr ctermbg=235 guibg=#262626
augroup END

" }}}
