{1 "Olical/conjure"
 :ft [:clojure :fennel :python]
 :lazy true
 :init #(do
          ;; dont auto-start repls
          (set vim.g.conjure#client_on_load false)
          ;; key bindings
          ;; TODO: some of these conflict with lsp settings . . . should decide
          ;; whether to use conjure or lsp :/
          (set vim.g.conjure#mapping#doc_word "k") ; use K for lsp for and ,k for conjure
          (set vim.g.conjure#mapping#eval_current_form ["cpp"])
          (set vim.g.conjure#mapping#eval_word ["cww"])
          (set vim.g.conjure#mapping#eval_marked_form ["cm"])
          (set vim.g.conjure#mapping#eval_motion ["cp"])
          (set vim.g.conjure#mapping#eval_root_form ["cp-"])
          ; (set vim.g.conjure#mapping#def_word ["gd"])
          (set vim.g.conjure#mapping#def_word "d")
          ;; this one isn't working???
          ; (set vim.g.conjure#mapping#eval_buf ["\\<Leader>E"])
          )}
