" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath = &runtimepath
" source ~/.vimrc

" -- Fennel -------------------------------------------------------------------

if has('nvim')
  lua require('bootstrap-fennel')

  " TODO: move this to init-fnl or something?

  " Fennel and lua commands
  command! -nargs=1 Fnl :lua require('fennel').eval([=====[ <args> ]=====])
  command! -nargs=1 FnlPrint :lua print(require('fennel').eval([=====[ <args> ]=====]))
  command! -nargs=1 FnlView :lua _G.fennel_pprint(require('fennel').eval([=====[ <args> ]=====]))
  command! -nargs=1 LuaPrint :lua print(<args>)
  command! -nargs=1 LuaInspect :lua print(vim.inspect(<args>))

  " Require (reload with !) a lua or fennel module
  command! -bar -nargs=1 -bang Require Fnl (if (= :! <q-bang>) (_G.require! <q-args>) (require <q-args>))

  " Based on https://github.com/wbthomason/dotfiles/blob/9134e87b00102cda07f875805f900775244067fe/neovim/.config/nvim/init.lua#L99-L103
  command! PackerClean   Require! plugins | lua require('packer').clean()
  command! PackerCompile Require! plugins | lua require('packer').compile()
  command! PackerStatus  Require! plugins | lua require('packer').status()
  command! PackerInstall Require! plugins | lua require('packer').install()
  command! PackerSync    Require! plugins | lua require('packer').sync()
  command! PackerUpdate  Require! plugins | lua require('packer').update()
endif


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

" linewise jk
nnoremap k gk
nnoremap j gj

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

try
  let g:gruvbox_material_palette = "material"
  if has('mac')
    let g:gruvbox_material_background = "medium"
  else
    let g:gruvbox_material_background = "hard"
  endif
  let g:gruvbox_material_ui_contrast = "high"
  let g:gruvbox_material_disable_italic_comment = 1
  let g:gruvbox_material_enable_bold = 1
  let g:gruvbox_material_better_performance = 1
  colorscheme gruvbox-material
catch
  colorscheme zenburn
endtry


" -- Remap some common mistakes -----------------------------------------------

" I never use the command line window
nmap q: :q
nmap Q: :q

" Typos for :q and :qa
cnoreabbrev Q q
cnoreabbrev qA qa
cnoreabbrev QA qa
cnoreabbrev Qa qa
