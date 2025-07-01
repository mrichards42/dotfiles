;; Turn off distracting linting indicators
(vim.diagnostic.config
 {:virtual_text false
  :underline true})

(local lsp-servers
  {:dockerls {}
   ;; Note: you're still going to have to install extensions, e.g.
   ;; :PylspInstall python-lsp-black python-lsp-ruff
   :pylsp {:settings {:pylsp {:plugins {;; sort imports with ruff
                                        :ruff {:format ["I"]}
                                        :rope_autoimport {:enabled true}}}}}
   :bashls {:filetypes [:sh :bash :zsh]}
   :clojure_lsp {}
   :terraformls {}})

;; TODO: cleanup -- other autocmmds from kickstart.nvim?
(fn lsp-config []

  ;;; configure lsp servers
  (let [;; have to tell servers that the client expects completions
        ;; https://github.com/hrsh7th/cmp-nvim-lsp?tab=readme-ov-file#capabilities
        (ok? cmp-nvim-lsp) (pcall require :cmp_nvim_lsp)
        default-config (if ok? {:capabilities (cmp-nvim-lsp.default_capabilities)} {})]
    (each [name cfg (pairs lsp-servers)]
      (vim.lsp.config name (vim.tbl_deep_extend :force default-config cfg))))

  ;;; Keybindings
  ;; TODO: cleanup
  (fn on-attach []
    (let [existing-keys (collect [_ m (ipairs (vim.api.nvim_buf_get_keymap 0 :n))]
                          (values m.lhs m.lhs))
          has-mapping? (fn [key]
                         (. existing-keys (key:gsub "<leader>" vim.g.mapleader)))
          map-key (fn [key f opts]
                    (when (or (?. opts :force) (not (has-mapping? key)))
                      (vim.keymap.set :n key f {:noremap true :silent true :buffer bufnr})))]

      ;; TODO: should only bind keys if the language server supports these
      ;; operations? Otherwise I have some mappings set up elsewhere (like
      ;; <leader>lf) that these override.

      ;; the standard set of keys in lspconfig -- these might already be set?
      ; (map-key "gD" vim.lsp.buf.declaration)
      (map-key "gd" vim.lsp.buf.definition)
      ; (map-key "K" vim.lsp.buf.hover)           ; this is the default
      (map-key "<C-k>" vim.lsp.buf.signature_help)
      ; (map-key "gi" vim.lsp.buf.implementation) ; get used to default: gri
      ; (map-key "gr" vim.lsp.buf.references)     ; get used to default: grr
      (map-key "[d" vim.diagnostic.goto_prev)
      (map-key "]d" vim.diagnostic.goto_next)
      ;; all the leader keys from lspconfig, but prefixed
      ;; with "l" for "lsp"
      (map-key "<leader>ld" vim.lsp.buf.type_definition)
      (map-key "<leader>lr" vim.lsp.buf.rename)
      (map-key "<leader>la" vim.lsp.buf.code_action)
      (map-key "<leader>le" vim.diagnostic.open_float)
      (map-key "<leader>lq" vim.diagnostic.setloclist)
      (map-key "<leader>lf"
               #(vim.lsp.buf.format {:async true})
               {:force true})))

  (vim.api.nvim_create_autocmd
   :LspAttach
   {:group (vim.api.nvim_create_augroup :my-lsp-attach {:clear true})
    :callback on-attach}))

;; TODO: only enable things that are installed?
;; TODO: install prettierd? (for markdown?)
(fn null-ls-config []
  (let [null-ls (require :null-ls)]
    {:sources [
               ; (null-ls.builtins.formatting.prettier.with
               ;   {:only_local "node_modules/.bin"})
               ; (null-ls.builtins.diagnostics.sqlfluff.with
               ;   {:extra_args {:--dialect "postgres"}})
               ; null-ls.builtins.diagnostics.eslint_d
               ; (null-ls.builtins.formatting.cljstyle.with
               ;   {:command "cljfmt"
               ;    :args ["fix" "-q" "-"]})
               (null-ls.builtins.formatting.zprint.with
                {:command "zprint"
                 :args ["{:search-config? true}"]})]
     :diagnostics_format "[#{c}] #{m} (#{s})"}))

[{1 "neovim/nvim-lspconfig"
  :dependencies [{1 "williamboman/mason.nvim" :opts {}}
                 {1 "williamboman/mason-lspconfig.nvim"
                  ; :version "v1.32.0"
                  :opts {:ensure_installed (vim.tbl_keys lsp-servers)}}]
  :config lsp-config}
 {1 "nvimtools/none-ls.nvim"
  :dependencies ["nvim-lua/plenary.nvim"]
  :opts null-ls-config}
 {1 "folke/trouble.nvim"
  :opts {}
  :cmd :Trouble
  :keys [["<leader>xx" "<cmd>Trouble diagnostics toggle<cr>"]]}]
