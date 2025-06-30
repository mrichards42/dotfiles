{1 "sainnhe/gruvbox-material"
 :lazy false
 :priority 1000
 :config #(do
            (set vim.opt.termguicolors true)
            (set vim.opt.background "dark")
            (set vim.g.gruvbox_material_foregroud "material")
            (set vim.g.gruvbox_material_background "medium")
            (set vim.g.gruvbox_material_ui_contrast "high")
            (set vim.g.gruvbox_material_disable_italic_comment 1)
            (set vim.g.gruvbox_material_enable_bold 1)
            (set vim.g.gruvbox_material_better_performance 1)
            (vim.cmd.colorscheme "gruvbox-material"))}
