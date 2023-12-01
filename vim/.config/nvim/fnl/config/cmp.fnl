(local cmp (require :cmp))
(local lspconfig (require :lspconfig))

;; this mostly just the recommended config from the readme
(cmp.setup
 {:snippet {:expand #((. vim.fn :vsnip#anonymous) $.body)}
  :sources (cmp.config.sources
            [{:name "nvim_lsp"}
             {:name "buffer"}
             {:name "path"}])
  :mapping (cmp.mapping.preset.insert
            {:<C-b> (cmp.mapping.scroll_docs -4)
             :<C-f> (cmp.mapping.scroll_docs 4)
             :<C-Space> (cmp.mapping.complete)
             :<C-e> (cmp.mapping.abort)
             :<CR> (cmp.mapping.confirm {:select true})})})

(cmp.setup.cmdline "/" {:mapping (cmp.mapping.preset.cmdline)
                        :sources (cmp.config.sources
                                  [{:name "buffer"}])})

(cmp.setup.cmdline ":" {:mapping (cmp.mapping.preset.cmdline)
                        :sources (cmp.config.sources
                                  [{:name "fuzzy_path"}
                                   {:name "cmdline"}])})

;; dadbod completion
(cmp.setup.filetype "sql" {:sources (cmp.config.sources
                                     [{:name "vim-dadbod-completion"}
                                      {:name "buffer"}])})
