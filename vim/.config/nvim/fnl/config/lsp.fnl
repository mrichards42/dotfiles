(local null-ls (require :null-ls))
; (local sqlfluff (_G.require! :null_ls_sqlfluff))
(local nvim-lsp (require :lspconfig))
(local typescript-tools (require :typescript-tools))
(local cmp-nvim-lsp (require :cmp_nvim_lsp))

(fn merge [a b]
  (let [ret {}]
    (collect [k v (pairs a) :into ret] (values k v))
    (collect [k v (pairs b) :into ret] (values k v))
    ret))

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

;; -- Configure lsp clients --

(fn attach-std [client bufnr]
  ;; omnifunc
  (vim.api.nvim_buf_set_option bufnr :omnifunc  "v:lua.vim.lsp.omnifunc")

  ;; buffer-local key maps
  (each [key cmd (pairs {;; the standard set of keys in lspconfig
                         :gD vim.lsp.buf.declaration
                         :gd vim.lsp.buf.definition
                         :K vim.lsp.buf.hover
                         :<C-k> vim.lsp.buf.signature_help
                         :gi vim.lsp.buf.implementation
                         :gr vim.lsp.buf.references
                         "[d" vim.diagnostic.goto_prev
                         "]d" vim.diagnostic.goto_next
                         ;; all the leader keys from lspconfig, but prefixed
                         ;; with "l" for "lsp"
                         "<leader>ld" vim.lsp.buf.type_definition
                         "<leader>lr" vim.lsp.buf.rename
                         "<leader>lca" vim.lsp.buf.code_action
                         "<leader>le" vim.diagnostic.open_float
                         "<leader>lq" vim.diagnostic.setloclist
                         "<leader>lf" #(vim.lsp.buf.format {:async true})})]
    (vim.keymap.set :n key cmd {:noremap true :silent true :buffer bufnr})))

(null-ls.setup
 {:sources [(null-ls.builtins.diagnostics.shellcheck.with
             {:filetypes [:sh :bash :zsh]})
            (null-ls.builtins.formatting.prettier.with
             {:only_local "node_modules/.bin"})
            (null-ls.builtins.diagnostics.sqlfluff.with
             {:extra_args {:--dialect "postgres"}})
            null-ls.builtins.diagnostics.eslint_d
            (null-ls.builtins.formatting.cljstyle.with
             {:command "cljfmt"
              :args ["fix" "-q" "-"]})]
  :diagnostics_format "[#{c}] #{m} (#{s})"
  :on_attach attach-std})

(local std-cfg
  {:on_attach attach-std
   :flags {:debounce_text_changes 150}
   ;; nvim-cmp integration
   :capabilities (cmp-nvim-lsp.default_capabilities)})

(typescript-tools.setup
  (merge
    std-cfg
    {:on_attach (fn [client bufnr]
                  ;; hack typescript-tools to tell it not to do formatting (use null-ls w/ prettier)
                  (set client.server_capabilities.documentFormattingProvider false)
                  (set client.server_capabilities.documentRangeFormattingProvider false)
                  ;; the rest
                  (attach-std client bufnr))}))

(nvim-lsp.dockerls.setup std-cfg)
