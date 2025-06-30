-- [nfnl] Compiled from fnl/plugins/colorscheme.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  vim.opt.termguicolors = true
  vim.opt.background = "dark"
  vim.g.gruvbox_material_foregroud = "material"
  vim.g.gruvbox_material_background = "medium"
  vim.g.gruvbox_material_ui_contrast = "high"
  vim.g.gruvbox_material_disable_italic_comment = 1
  vim.g.gruvbox_material_enable_bold = 1
  vim.g.gruvbox_material_better_performance = 1
  return vim.cmd.colorscheme("gruvbox-material")
end
return {"sainnhe/gruvbox-material", priority = 1000, config = _1_, lazy = false}
