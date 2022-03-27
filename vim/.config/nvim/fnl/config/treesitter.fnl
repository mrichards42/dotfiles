(local treesitter-configs (require "nvim-treesitter.configs"))
(treesitter-configs.setup
 {:ensure_installed "maintained" ; one of "all", "maintained" (parsers with maintainers), or a list of languages
  :sync_install false ; install languages synchronously (only applied to `ensure_installed`)
  :highlight
  {:enable true
   ;; treesitter highlighting is weird for lisps
   :disable [:fennel :clojure]
   ;; for spell checking
   :additional_vim_regex_highlighting true}
  ;; requires nvim-ts-context-commentstring
  :context_commentstring {:enable true}})
