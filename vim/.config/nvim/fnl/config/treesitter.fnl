(local treesitter-configs (require :nvim-treesitter.configs))
(local treesitter-install (require :nvim-treesitter.install))

(set treesitter-install.prefer_git true)

(treesitter-configs.setup
 {:ensure_installed [:bash
                     :clojure
                     :cpp
                     :css
                     :dockerfile
                     :dot
                     :elixir
                     :erlang
                     :fennel
                     :go
                     :javascript
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
                     :sql
                     :toml
                     :tsx
                     :typescript
                     :vim
                     :vimdoc
                     :yaml]
  :sync_install false ; install languages synchronously (only applied to `ensure_installed`)
  :highlight
  {:enable true
   ;; treesitter highlighting is weird for lisps
   :disable [:fennel :clojure]
   ;; for spell checking
   :additional_vim_regex_highlighting true}})
