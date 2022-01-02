(local null-ls (require :null-ls))
(local sqlfluff (_G.require! :null_ls_sqlfluff))
(local nvim-lsp (require :lspconfig))

;; Turn off the distracting linting indicators
(vim.diagnostic.config
 {:virtual_text false
  :underline false})

;; Print diagnostics to the command window on hover
;; Cribbed from https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#print-diagnostics-to-message-area
;; and https://gitlab.com/yorickpeterse/dotfiles/-/blob/a1fd1cbc17bd33990f0ccacd9d7cc8feb26d8436/dotfiles/.config/nvim/lua/dotfiles/diagnostics.lua
(var has-diagnostic? false)

(fn _G.PrintDiagnostics [opts bufnr linenr client_id]
  (let [diagnostics (vim.lsp.diagnostic.get_line_diagnostics
                     (or bufnr 0)
                     (or linenr (- (vim.fn.line ".") 1))
                     (or opts {})
                      client_id)]
    (match (length diagnostics)
      0 (when has-diagnostic?
          (vim.cmd "echo ''"))
      1 (print (. diagnostics 1 :message))
      _ (print (table.concat 
                 (icollect [_ diagnostic (ipairs diagnostics)]
                   diagnostic.message)
                 "; ")))
    (set has-diagnostic? (not= 0 (length diagnostics)))))

(vim.cmd "autocmd CursorHold * lua PrintDiagnostics()")

;; Configure lsp clients

(fn on-attach [client bufnr]
  ;; omnifunc
  (vim.api.nvim_buf_set_option bufnr :omnifunc  "v:lua.vim.lsp.omnifunc")

  ;; buffer-local key maps
  (each [key cmd (pairs {;; the standard set of keys in lspconfig
                         :gD "vim.lsp.buf.declaration()"
                         :gd "vim.lsp.buf.definition()"
                         :K "vim.lsp.buf.hover()"
                         :<C-k> "vim.lsp.buf.signature_help()"
                         :gi "vim.lsp.buf.implementation()"
                         :gr "vim.lsp.buf.references()"
                         :gr "vim.lsp.buf.references()"
                         "[d" "vim.diagnostic.goto_prev()"
                         "]d" "vim.diagnostic.goto_next()"
                         ;; all the leader keys from lspconfig, but prefixed
                         ;; with "l" for "lsp"
                         "<leader>ld" "vim.lsp.buf.type_definition()"
                         "<leader>lrn" "vim.lsp.buf.rename()"
                         "<leader>lca" "vim.lsp.buf.code_action()"
                         "<leader>le" "vim.diagnostic.open_float()"
                         "<leader>lq" "vim.diagnostic.setloclist()"
                         "<leader>lf" "vim.buf.formatting()"})]
    (vim.api.nvim_buf_set_keymap bufnr :n
                                 key
                                 (.. "<cmd>lua " cmd "<cr>")
                                 {:noremap true :silent true})))

(null-ls.setup
 {:sources [(null-ls.builtins.diagnostics.shellcheck.with
              {:filetypes [:sh :bash :zsh]})
            sqlfluff]
  :diagnostics_format "[#{c}] #{m} (#{s})"
  :on_attach on-attach})


(each [_ lsp (ipairs [:tsserver])]
  ((. nvim-lsp lsp :setup)
   {:on_attach on-attach
    :flags {:debounce_text_changes 150}}))
