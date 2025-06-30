" -- Basics -------------------------------------------------------------------

filetype plugin indent on

let mapleader = "\<Space>"
let maplocalleader = ","

" 2-space indent, no tabs, 79 columns
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set textwidth=79

set cursorline           " highlight the current line
set colorcolumn=+1       " highlight the 80th column (textwidth + 1)

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

" format the whole file (overridden in lsp config)
map <leader>lf gg=G``

" linewise jk
nnoremap k gk
nnoremap j gj

set incsearch            " incremental search
set ignorecase           " case-insensitive search ...
set smartcase            " ... unless the search term has a capital
set hlsearch             " highlight searches
map <Leader>h :nohlsearch<CR>

" -- Remap some common mistakes -----------------------------------------------

" I never use the command line window
nmap q: :q
nmap Q: :q

" Typos for :q and :qa
cnoreabbrev Q q
cnoreabbrev qA qa
cnoreabbrev QA qa
cnoreabbrev Qa qa

" TODO: can this go in my own sexp.vim plugin?
" let g:sexp_filetypes = "lisp,scheme,clojure,fennel"

" -- Lazy.nvim bootstrap ------------------------------------------------------

lua << EOF

 local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
 if not (vim.uv or vim.loop).fs_stat(lazypath) then
   local lazyrepo = "https://github.com/folke/lazy.nvim.git"
   local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
   if vim.v.shell_error ~= 0 then
     vim.api.nvim_echo({
       { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
       { out, "WarningMsg" },
       { "\nPress any key to exit..." },
     }, true, {})
     vim.fn.getchar()
     os.exit(1)
   end
 end
 vim.opt.rtp:prepend(lazypath)

 -- Source plugin/*.vim before Lazy init. Lazy intentionally loads these
 -- **after** its own plugin init which breaks my personal vim plugins.
 local vim_plugins = vim.fn.glob(
   vim.fn.stdpath("config") .. "/plugin/*.vim",
   --[[nosuf]] false,
   --[[list]] true
 )
 for _, f in ipairs(vim_plugins) do
   vim.cmd("source " .. f)
 end

 require("lazy").setup("plugins")

EOF
