;; I used to use vim-polyglot, but it doesn't seem to play nice with a lot of
;; the rest of the setup I have (e.g. markdown has always been a nightmare with
;; polygplot+treesitter+prettier). Instead I'll just add a few individual
;; language plugins that are helpful on top of whatever treesitter provides.

;; uses 4-space indent, which messes up bulleted lists IMO
(set vim.g.markdown_recommended_style 0)

(set vim.g.sql_type_default "pgsql")

["clojure-vim/clojure.vim"
 "jaawerth/fennel.vim"
 "lifepillar/pgsql.vim"
 ;; sexp
 {1 "tpope/vim-sexp-mappings-for-regular-people"
  :dependencies ["guns/vim-sexp"]}
 ]
