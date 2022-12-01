(local treesitter-configs (require "nvim-treesitter.configs"))
(treesitter-configs.setup
 {:ensure_installed [:bash
                     :clojure
                     :cpp
                     :css
                     :dockerfile
                     :dot
                     :fennel
                     :go
                     :javascript
                     :help
                     :hcl
                     :html
                     :jsdoc
                     :json
                     :lua
                     :make
                     :markdown
                     :perl
                     :prisma
                     :python
                     :r
                     :regex
                     :rst
                     :ruby
                     :rust
                     :scss
                     :toml
                     :tsx
                     :typescript
                     :vim
                     :yaml]
  :sync_install false ; install languages synchronously (only applied to `ensure_installed`)
  :highlight
  {:enable true
   ;; treesitter highlighting is weird for lisps
   :disable [:fennel :clojure]
   ;; for spell checking
   :additional_vim_regex_highlighting true}
  ;; requires nvim-ts-context-commentstring
  :context_commentstring {:enable true}})
