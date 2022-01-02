" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
" source ~/.vimrc

lua require('bootstrap-fennel')
lua require('plugins')

command -nargs=+ Fnl :lua print(require('fennel').eval([[ <args> ]]))


" -- Basics -------------------------------------------------------------------

filetype plugin indent on

let mapleader = "\<Space>"

" 2-space indent, no tabs, 79 columns
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set textwidth=79

" show space/tab characters
set list
set listchars=tab:>\ ,trail:·,nbsp:␣

set foldmethod=marker    " use {{{ }}} for folds
set mouse=a              " allow mouse everywhere
set nomodeline           " security
set nowrap
set number               " line numbers
set spell                " spellchecking, generally just in comments / strings
set splitright           " prefer right splits instead of left (for :vsplit)


" -- Search -------------------------------------------------------------------

set incsearch            " incremental search
set ignorecase           " case-insensitive search ...
set smartcase            " ... unless the search term has a capital
set hlsearch             " highlight searches
map <Leader>h :nohlsearch<CR>


" -- Theme --------------------------------------------------------------------

if exists('+termguicolors')
  " 24-bit color (makes highlight groups use 'gui*' instead of 'cterm*')
  set termguicolors
endif

set cursorline           " highlight the current line
set colorcolumn=+1       " highlight the 80th column (textwidth + 1)
set background=dark

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  colorscheme base16-tomorrow-night
  source ~/.vimrc_background   " this is always a base16 colorscheme

  " dimmer highlight colors
  hi Search ctermfg=018 ctermbg=017
  hi WildMenu ctermfg=018 ctermbg=017

  " dimmer matching bracket
  hi MatchParen ctermfg=16 ctermbg=241
else
  colorscheme zenburn
endif
