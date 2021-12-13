(local packer (require "packer"))

(macro t [...])

(set _G.require!
    (fn require! [name]
      (tset package.loaded name nil)
      (require name)))

(packer.startup
 (fn [use]
   (macro use* [pkg ...]
     "Like packer's `use`, but with lispy syntax:
     
     Instead of

       use {'user/plugin', key = value}

     It's

      (use \"user/plugin\"
           {:key value})
           
     Compare to without the macro:

       (use {[1] \"user/plugin\"
             :key value})
     
     Or

       (use (doto [\"user/plugin\"]
              (tset :key value})))"
     ; `(use
     ;    ,(let [tbl [pkg]
     ;           kvs [...]]
     ;       (for [i 1 (length kvs) 2]
     ;         (tset tbl (. kvs i) (. kvs (+ 1 i))))
     ;       tbl))
     ;; this might be nicer ...
     `(use ,(doto (or ... {}) (tset 1 pkg)))
     )

   (use "wbthomason/packer.nvim")

   ;; tpope
   (use "tpope/vim-sensible")
   (use "tpope/vim-eunuch")      ; shell commands
   (use "tpope/vim-unimpaired")  ; square bracked mappings
   (use "tpope/vim-commentary")  ; toggling comments
   (use "tpope/vim-repeat")      ; used by multiple plugins for "." repeating
   (use "tpope/vim-rsi")         ; readline keys in insert mode
   (use "tpope/vim-surround")    ; paren mappings
   (use "guns/vim-sexp")
   (use "tpope/vim-sexp-mappings-for-regular-people")

   ;; git
   (use "tpope/vim-fugitive")
   (use "junegunn/gv.vim")
   (use "tpope/vim-rhubarb")

   ;; language

   (use* "sheerun/vim-polyglot"
         {:setup #(set vim.g.polyglot_disabled ["sql"])})
   ; More up to date than polyglot
   ; (use (doto ["lifepillar/pgsql.vim"]
   ;     (tset :config #(set vim.g.sql_type_default "pgsql"))))
   ; (use {[0] "lifepillar/pgsql.vim"
   ;       :config #(set vim.g.sql_type_default "pgsql")})
   (use* "lifepillar/pgsql.vim"
         {:config #(set vim.g.sql_type_default "pgsql")})
   ; let g:polyglot_disabled = ['markdown', 'pgsql']

   (use* "nvim-treesitter/nvim-treesitter"
         {:run ":TSUpdate"
          :config #(require! "config.treesitter")})

   ;; db
   (use "tpope/vim-dadbod")

   ;; colors
   ;; TODO: for now I'm just using tomrorow-night again (in init.vim) but look
   ;; around for something -- overall I like 'lake', but it needs a fe more
   ;; colors -- could use a blue or a purple (and needs more contrast w/ the
   ;; background, which I can get w/ colortuner). Think about it again once
   ;; we've seen treesitter
   (use "chriskempson/base16-vim")

   (use* "zefei/vim-colortuner"
        {:disable true})
   (use* "antonk52/lake.vim"
         {:disable true
          :config #(vim.cmd "colorscheme lake")})
   (use* "sainnhe/everforest"
         {:disable true
          :config #(do
                     (set vim.g.everforest_background "hard")
                     (vim.cmd "colorscheme everforest"))
          :after "lake.vim"})
   (use* "sainnhe/gruvbox-material"
         {:disable true
          :config #(do
                     (set vim.g.gruvbox_material_palette "material")
                     (set vim.g.gruvbox_material_background "hard")
                     (vim.cmd "colorscheme gruvbox-material")
                     )})
   (use* "sainnhe/edge"
         {:disable true
          :config #(do
                     (set vim.g.edge_background "hard")
                     (vim.cmd "colorscheme edge"))})
   (use* "squarefrog/tomorrow-night.vim"
         {:disable true
          :config #(vim.cmd "colorscheme tomorrow-night")})

   (print "packer startup")))


(doto vim.o
  (tset :modeline false)
  (tset :number true)
  (tset :wrap false)
  (tset :mouse "a")
  (tset :splitright true)
  (tset :modeline false)
  
  ;; whitespace
  (tset :expandtab true)
  (tset :shiftwidth 2)
  (tset :tabstop 2)
  (tset :softtabstop 2)

  ;; wrapping
  (tset :textwidth 79)
  (tset :colorcolumn "+1")
  (tset :foldmethod "marker")

  ;; colors
  )

(if (vim.fn.exists "+termguicolors")
  (set vim.o.termguicolors true))
