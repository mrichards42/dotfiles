-- [nfnl] fnl/plugins/treesitter.fnl
local function _1_()
  local install = require("nvim-treesitter.install")
  local configs = require("nvim-treesitter.configs")
  install.prefer_git = true
  return configs.setup({ensure_installed = {"bash", "clojure", "cpp", "css", "dockerfile", "dot", "elixir", "erlang", "fennel", "go", "javascript", "hcl", "html", "jsdoc", "json", "jsonnet", "lua", "make", "markdown", "perl", "prisma", "python", "r", "regex", "rst", "ruby", "rust", "scss", "sql", "toml", "tsx", "typescript", "terraform", "vim", "vimdoc", "yaml"}, highlight = {enable = true, disable = {"fennel", "clojure"}, additional_vim_regex_highlighting = true}, sync_install = false})
end
return {{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = _1_}, "JoosepAlviste/nvim-ts-context-commentstring"}
