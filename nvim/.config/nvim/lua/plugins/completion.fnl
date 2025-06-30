[{1 "hrsh7th/nvim-cmp"
  :event "InsertEnter"
  :dependencies ["hrsh7th/cmp-buffer"
                 "hrsh7th/cmp-nvim-lsp"
                 "PaterJason/cmp-conjure"
                 "hrsh7th/cmp-path"]
  :opts (fn []
          (local cmp (require :cmp))
          {:sources (cmp.config.sources
                     [;; group 1
                      [{:name "buffer"}
                       {:name "nvim_lsp"}
                       {:name "conjure"}]
                      ;; group 2 (once we run out of suggestions from group 1)
                      [{:name "path"}]])
           :mapping (cmp.mapping.preset.insert
                     ;; these are just the nvim-cmp defaults
                     {"<C-b>" (cmp.mapping.scroll_docs -4)
                      "<C-f>" (cmp.mapping.scroll_docs 4)
                      "<C-n>" (cmp.mapping.select_next_item {:behavior cmp.SelectBehavior.Insert})
                      "<C-p>" (cmp.mapping.select_prev_item {:behavior cmp.SelectBehavior.Insert})
                      "<C-Space>" (cmp.mapping.complete)
                      "<C-e>" (cmp.mapping.abort)
                      "<CR>" (cmp.mapping.confirm {:select true})})
           :formatting (. (require :nvim-highlight-colors) :format)})}]
