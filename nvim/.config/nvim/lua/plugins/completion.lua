-- [nfnl] lua/plugins/completion.fnl
local function _1_()
  local cmp = require("cmp")
  return {sources = cmp.config.sources({{{name = "buffer"}, {name = "nvim_lsp"}, {name = "conjure"}}, {{name = "path"}}}), mapping = cmp.mapping.preset.insert({["<C-b>"] = cmp.mapping.scroll_docs(-4), ["<C-f>"] = cmp.mapping.scroll_docs(4), ["<C-n>"] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Insert}), ["<C-p>"] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Insert}), ["<C-Space>"] = cmp.mapping.complete(), ["<C-e>"] = cmp.mapping.abort(), ["<CR>"] = cmp.mapping.confirm({select = true})}), formatting = require("nvim-highlight-colors").format}
end
return {{"hrsh7th/nvim-cmp", event = "InsertEnter", dependencies = {"hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp", "PaterJason/cmp-conjure", "hrsh7th/cmp-path"}, opts = _1_}}
