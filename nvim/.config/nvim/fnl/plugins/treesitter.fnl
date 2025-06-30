[{1 "nvim-treesitter/nvim-treesitter"
  :build ":TSUpdate"
  :config #(let [install (require :nvim-treesitter.install)
                 configs (require :nvim-treesitter.configs)]
             (set install.prefer_git true)
             (configs.setup
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
                                   :terraform
                                   :vim
                                   :vimdoc
                                   :yaml]
                :sync_install false
                :highlight {:enable true
                            ;; treesitter highlighting is weird for lisps
                            :disable [:fennel :clojure]
                            ;; for spell checking
                            :additional_vim_regex_highlighting true}}))}
 "JoosepAlviste/nvim-ts-context-commentstring"]
