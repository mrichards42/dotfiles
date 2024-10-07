(local {: use &as packer} (require :packer))

(packer.init
 {:display {:open_fn (. (require :packer.util) :float)}
  :disable_commands true})

(packer.reset)

(use "wbthomason/packer.nvim")


;; -- tpope essentials --------------------------------------------------------

(use "tpope/vim-sensible")
(use "tpope/vim-eunuch")      ; shell commands
(use "tpope/vim-unimpaired")  ; square bracked mappings
(use "tpope/vim-commentary")  ; toggling comments
(use "tpope/vim-repeat")      ; used by multiple plugins for "." repeating
(use "tpope/vim-rsi")         ; readline keys in insert mode
(use "tpope/vim-surround")    ; paren mappings
(use "tpope/vim-abolish")     ; case-preserving replacements
(use {1 "tpope/vim-sexp-mappings-for-regular-people"
      :requires ["guns/vim-sexp"]})


;; -- git ---------------------------------------------------------------------

(use "tpope/vim-fugitive")
(use "junegunn/gv.vim")
(use "tpope/vim-rhubarb")


;; -- languages ---------------------------------------------------------------

(use {1 "sheerun/vim-polyglot"
      :setup #(set vim.g.polyglot_disabled ["sql"])})

;; More up to date than polyglot
(use {1 "lifepillar/pgsql.vim"
      :config #(set vim.g.sql_type_default "pgsql")})


;; -- treesitter --------------------------------------------------------------

(use {1 "nvim-treesitter/nvim-treesitter"
      :run ":TSUpdate"
      :config #(_G.require! :config.treesitter)})

(use {1 "JoosepAlviste/nvim-ts-context-commentstring"
      :config #(set vim.g.skip_ts_context_commentstring_module true)})

(use {1 "nvim-treesitter/playground"
      :cmd "TSHighlightCapturesUnderCursor"})


;; -- lsp ---------------------------------------------------------------------

(use {1 "neovim/nvim-lspconfig"
      :requires ["jose-elias-alvarez/null-ls.nvim"
                 "nvim-lua/plenary.nvim"]
      :config #(_G.require! :config.lsp)})

;; -- completion --------------------------------------------------------------

(use {1 "hrsh7th/cmp-nvim-lsp"
      :requires ["hrsh7th/cmp-buffer"
                 "hrsh7th/cmp-path"
                 "hrsh7th/cmp-cmdline"
                 "hrsh7th/nvim-cmp"
                 "hrsh7th/vim-vsnip"
                 "hrsh7th/cmp-vsnip"
                 {1 "tzachar/cmp-fuzzy-path"
                  :requires ["tzachar/fuzzy.nvim"]}]
      :config #(_G.require! :config.cmp)})


;; -- telescope ---------------------------------------------------------------

(use {1 "nvim-telescope/telescope.nvim"
      :requires ["nvim-lua/plenary.nvim"
                 {1 "nvim-telescope/telescope-fzf-native.nvim"
                  :run "make"}]
      :config #(_G.require! :config.telescope)})


;; -- colors ------------------------------------------------------------------

;; the current theme
(use "sainnhe/gruvbox-material")

;; the previous theme (tomorrow-night)
(use "chriskempson/base16-vim")

;; a few additional reasonable themes

(use {1 "mcchrish/zenbones.nvim"
      :requires "rktjmp/lush.nvim"})

(use "w0ng/vim-hybrid")

(use "kristijanhusak/vim-hybrid-material")

(use "sainnhe/everforest")

;; color utils
(use {1 "zefei/vim-colortuner"
      :cmd "Colortuner"})


;; -- js/ts -------------------------------------------------------------------

(use {1 "pmizio/typescript-tools.nvim"
      :requires ["nvim-lua/plenary.nvim"
                 "neovim/nvim-lspconfig"]})


;; -- clojure -----------------------------------------------------------------

(use "Olical/conjure")
(use "PaterJason/cmp-conjure")

;; -- db ----------------------------------------------------------------------

(use {1 "tpope/vim-dadbod"
      :cmd "DB"}) ;; db

(use "kristijanhusak/vim-dadbod-completion")

;; -- misc --------------------------------------------------------------------

(use "godlygeek/tabular")
