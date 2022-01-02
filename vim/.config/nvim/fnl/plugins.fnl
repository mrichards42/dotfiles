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
(use {1 "tpope/vim-sexp-mappings-for-regular-people"
      :requires {1 "guns/vim-sexp" :opt true}
      ;; TODO: use the insert mode mappings I created the old version of the
      ;; clojure dotfiles
      ;; defaults plus fennel
      :setup #(set vim.g.sexp_filetypes "lisp,scheme,clojure,fennel")
      :ft ["lisp" "scheme" "clojure" "fennel"]})


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

(use {1 "nvim-treesitter/playground"
      :cmd "TSHighlightCapturesUnderCursor"})


;; -- lsp ---------------------------------------------------------------------

(use {1 "neovim/nvim-lspconfig"
      :requires ["jose-elias-alvarez/null-ls.nvim"
                 "nvim-lua/plenary.nvim"]
      :config #(_G.require! :config.lsp)})


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
(use {1 "EdenEast/nightfox.nvim"
      :config #((. (require :nightfox) :setup)
                {:fox :duskfox
                 :styles {:keywords :bold}})})

(use {1 "mcchrish/zenbones.nvim"
      :requires "rktjmp/lush.nvim"})

(use "w0ng/vim-hybrid")

(use "kristijanhusak/vim-hybrid-material")

(use "sainnhe/everforest")

;; color utils
(use {1 "zefei/vim-colortuner"
      :cmd "Colortuner"})


;; -- misc --------------------------------------------------------------------

(use {1 "tpope/vim-dadbod"
      :cmd "DB"}) ;; db
