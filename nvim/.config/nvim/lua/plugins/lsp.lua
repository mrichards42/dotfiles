-- [nfnl] fnl/plugins/lsp.fnl
vim.diagnostic.config({underline = true, virtual_text = false})
local lsp_servers = {dockerls = {}, pylsp = {settings = {pylsp = {plugins = {ruff = {format = {"I"}}, rope_autoimport = {enabled = true}}}}}, bashls = {filetypes = {"sh", "bash", "zsh"}}, clojure_lsp = {}, terraformls = {}}
local function lsp_config()
  do
    local ok_3f, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local default_config
    if ok_3f then
      default_config = {capabilities = cmp_nvim_lsp.default_capabilities()}
    else
      default_config = {}
    end
    for name, cfg in pairs(lsp_servers) do
      vim.lsp.config(name, vim.tbl_deep_extend("force", default_config, cfg))
    end
  end
  local function on_attach()
    local existing_keys
    do
      local tbl_16_ = {}
      for _, m in ipairs(vim.api.nvim_buf_get_keymap(0, "n")) do
        local k_17_, v_18_ = m.lhs, m.lhs
        if ((k_17_ ~= nil) and (v_18_ ~= nil)) then
          tbl_16_[k_17_] = v_18_
        else
        end
      end
      existing_keys = tbl_16_
    end
    local has_mapping_3f
    local function _3_(key)
      return existing_keys[key:gsub("<leader>", vim.g.mapleader)]
    end
    has_mapping_3f = _3_
    local map_key
    local function _4_(key, f, opts)
      local _6_
      do
        local t_5_ = opts
        if (nil ~= t_5_) then
          t_5_ = t_5_.force
        else
        end
        _6_ = t_5_
      end
      if (_6_ or not has_mapping_3f(key)) then
        return vim.keymap.set("n", key, f, {noremap = true, silent = true, buffer = bufnr})
      else
        return nil
      end
    end
    map_key = _4_
    map_key("gd", vim.lsp.buf.definition)
    map_key("<C-k>", vim.lsp.buf.signature_help)
    map_key("[d", vim.diagnostic.goto_prev)
    map_key("]d", vim.diagnostic.goto_next)
    map_key("<leader>ld", vim.lsp.buf.type_definition)
    map_key("<leader>lr", vim.lsp.buf.rename)
    map_key("<leader>la", vim.lsp.buf.code_action)
    map_key("<leader>le", vim.diagnostic.open_float)
    map_key("<leader>lq", vim.diagnostic.setloclist)
    local function _9_()
      return vim.lsp.buf.format({async = true})
    end
    return map_key("<leader>lf", _9_, {force = true})
  end
  return vim.api.nvim_create_autocmd("LspAttach", {group = vim.api.nvim_create_augroup("my-lsp-attach", {clear = true}), callback = on_attach})
end
local function null_ls_config()
  local null_ls = require("null-ls")
  return {sources = {null_ls.builtins.formatting.zprint.with({command = "zprint", args = {"{:search-config? true}"}})}, diagnostics_format = "[#{c}] #{m} (#{s})"}
end
return {{"neovim/nvim-lspconfig", dependencies = {{"williamboman/mason.nvim", opts = {}}, {"williamboman/mason-lspconfig.nvim", opts = {ensure_installed = vim.tbl_keys(lsp_servers)}}}, config = lsp_config}, {"nvimtools/none-ls.nvim", dependencies = {"nvim-lua/plenary.nvim"}, opts = null_ls_config}, {"folke/trouble.nvim", opts = {}, cmd = "Trouble", keys = {{"<leader>xx", "<cmd>Trouble diagnostics toggle<cr>"}}}}
