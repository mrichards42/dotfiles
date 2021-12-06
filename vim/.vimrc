""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Autogenerated by literate vim. Any edits will be overwritten
" Updated: 2021-11-04T13:29:02Z
" Source: /Users/mike/dotfiles/vim/.vimrc.md
" Output: /Users/mike/dotfiles/vim/.vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" bootstrap
let s:literatevim = fnamemodify(resolve(expand('<sfile>:p')), ':h') . '/literatevim '
augroup literatevimrc
  autocmd!
  autocmd BufWritePost *vimrc.md,*.vim.md exec '!' . s:literatevim . expand('%')
augroup END

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

" Defaults
set expandtab sw=2 ts=2 sts=2          " 2-space tabs
set list lcs=trail:·,nbsp:␣,tab:\>\    " show hidden characters

set textwidth=79 formatoptions-=t      " 79-char lines / don't auto-wrap
set colorcolumn=+1                     " highlight 80th character
set foldmethod=marker

augroup ws
  autocmd!
  autocmd FileType c,cpp,perl,python setl sw=4 ts=4 sts=4
  autocmd FileType vim setl fdm=marker
  autocmd FileType markdown setl wrap linebreak breakindent
  autocmd FileType GV set foldlevel=1
augroup END

" set timeoutlen=300

" linewise movement over soft wraps
noremap j gj
noremap k gk

" Indent/deindent using tab
imap <Tab> <C-t>
imap <S-Tab> <C-d>
vmap <Tab> > gv
vmap <S-Tab> < gv

nmap q: :q
nmap Q: :q
cnoreabbrev Q q
cnoreabbrev qA qa
cnoreabbrev QA qa
cnoreabbrev Qa qa

" Handy
cnoreabbrev vsb vertical sbuffer

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

augroup fzf
  autocmd!
  autocmd FileType fzf tnoremap <buffer> <Esc> <C-c>
augroup END

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

" fzf the echo'd result of running a command
command! -bang -nargs=+ Fecho
  \ call fzf#run(fzf#wrap('text', {'source': split(execute('<args>'), '\n')}, <bang>0))

" fzf scriptnames
command! -bang Fscriptnames
  \ call fzf#run(fzf#wrap('text', {
  \   'source': map(split(execute('scriptnames'), '\n'),
  \                 {key, val -> substitute(val, '\v^\s*[0-9.:]*\s+', "", "")})
  \ }, <bang>0))

set incsearch            " incremental search
set ignorecase smartcase " ignore case unless term has an uppercase char

" highlight all search terms / Leader-h removes highlight
set hlsearch
map <Leader>h :noh<CR>

function! s:project_dir(project_file)
  let path=expand('%:p:h') " Start with the current dir
  while path !~ '\v^[\.\/\\]$'
    let project_file=globpath(path, a:project_file)
    if project_file != ''
      return path
    endif
    " Knock off the current dir
    let path = fnamemodify(path, ':h')
  endwhile
endfunction

function! AutoProject(project_file, subdir_depth)
  let dir = s:project_dir(a:project_file)
  if dir != ''
    " And set this buffer's current dir
    exec 'lcd ' . dir
    " Set this buffer's search path to the directory with 'project.clj'
    let &l:path = dir . '/**' . a:subdir_depth
  endif
endfunction

augroup projectpaths
  autocmd!
  autocmd FileType clojure call AutoProject('project.clj', 3)
  autocmd FileType javascript call AutoProject('package.json', 3)
augroup END

let g:ale_disable_lsp = 1

let g:polyglot_disabled = ['markdown', 'clojure']
let g:markdown_fenced_languages = ['clj=clojure', 'bash=sh', 'vim', 'cpp']

call plug#begin('~/.vim/plugged')
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
  " Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " if has('nvim')
  "   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  " else
  "   Plug 'Shougo/deoplete.nvim'
  "   Plug 'roxma/nvim-yarp'
  "   Plug 'roxma/vim-hug-neovim-rpc'
  " endif
  Plug 'hrsh7th/nvim-compe'

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
  let g:sexp_filetypes = 'clojure,scheme,lisp,timl,fennel'
  Plug 'guns/vim-sexp'
  Plug 'tpope/vim-sexp-mappings-for-regular-people'
  Plug 'venantius/vim-cljfmt'
  "Plug 'clojure-vim/async-clj-omni'
  Plug 'clojure-vim/clojure.vim'

  " Fennel
  Plug 'bakpakin/fennel.vim'

  " Haskell
  Plug 'neovimhaskell/haskell-vim'

  " Table editing
  "Plug 'dhruvasagar/vim-table-mode'
  Plug 'godlygeek/tabular'

  " Helpful terminal interop
  Plug 'kassio/neoterm'

  " Misc other language packs
  Plug 'sheerun/vim-polyglot'

  " LSP and treesitter
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

" simple markdown tables
command! -nargs=0 MTable :Tabularize /|

" Don't auto-format files
let g:clj_fmt_autosave = 0

let g:neoterm_default_mod="vertical"   " open terminals in a vsplit
let g:neoterm_autoscroll=1             " scroll terminals after sending text
let g:neoterm_direct_open_repl=1       " don't open an intermediate shell

lua <<EOF
-- lsp setup copied from
-- https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- my additions:
  -- indent the file
  buf_set_keymap("n", "<Leader>=", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  -- indent a selection
  buf_set_keymap("v", "=", "<cmd>lua vim.lsp.buf.range_formatting()<CR><ESC>", opts)
  -- indent the current {} pair
  buf_set_keymap("n", "==", "<cmd>exec 'norm vaBab' <Bar> exec 'norm ='<CR>", { noremap=false, silent=false })
  -- indent the top level function
  buf_set_keymap("n", "=-", "<cmd>exec 'norm vabababababababaBaBaBaBaBaB' <Bar> exec 'norm ='<CR>", { noremap=false, silent=true})

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "tsserver" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enabled = true,
    -- additional_vim_regex_highlighting = true -- for indentation
  },
  indent = {
    enable = true
  }
}
EOF

lua <<EOF
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
  };
}
EOF

inoremap <silent><expr> <CR>      compe#confirm('<CR>')

" let g:deoplete#enable_at_startup = 1
" call deoplete#custom#option('keyword_patterns', {'clojure': '[\w!$%&*+/:<=>?@\^_~\-\.#]*'})

" Don't lint temp files
" Use eslint for .eslintrc.json files
let g:ale_pattern_options = {
\ '\V\^\(' . expand('$TMPDIR') . '\|/tmp\)': {'ale_linters': [], 'ale_fixers': []},
\ '\V.eslintrc.json\$': {'ale_linters': ['eslint']},
\}

let g:ale_pattern_options_enabled = 1

" Nicer error display (from ALE readme)
let g:ale_echo_msg_format = '[%linter%][%severity%] %code: %%s'

" GoTo code navigation.
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
" nnoremap <silent> K :call <SID>show_documentation()<CR>

" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   elseif (coc#rpc#ready())
"     call CocActionAsync('doHover')
"   else
"     execute '!' . &keywordprg . " " . expand('<cword>')
"   endif
" endfunction
" 
" command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

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

hi Whitespace ctermfg=241 guifg=#626262


augroup numbers
  autocmd!
  autocmd InsertEnter * hi LineNr ctermbg=60 guibg=#5f5f87
  autocmd InsertLeave * hi LineNr ctermbg=235 guibg=#262626
augroup END

augroup CursorLine
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setl cursorline
  autocmd WinLeave * setl nocursorline
augroup END

command! DebugSyntax for id in synstack(line("."), col(".")) | echo synIDattr(id, "name") | endfor

tnoremap <Esc> <C-\><C-n>

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

" Open a hidden terminal, optionally running a command
" Returns the buffer number
function! HiddenTerm(...)
  tabnew
  if a:0 > 0
    exe "terminal " . a:1
  else
    terminal
  endif
  setl bufhidden=hide
  let bufnr = bufnr('%')
  tabclose
  return bufnr
endfunction

" }}}

augroup cpy
  autocm!
  autocmd BufNewFile,BufRead *.cpy set ft=cpp
  autocmd BufNewFile,BufRead *.cpy setl expandtab sw=2 ts=2 sts=2
  " auto-indent off
  autocmd BufNewFile,BufRead *.cpy setl ai nocin nosi inde=
augroup END
