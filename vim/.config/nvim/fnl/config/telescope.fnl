(local telescope (require "telescope"))
(local actions (require "telescope.actions"))

(telescope.setup
  {:defaults {:mappings {:i {"<esc>" actions.close}}}
   :pickers {:colorscheme {:theme "dropdown"
                           :enable_preview true}
             :find_files {:hidden true}}})

(each [key cmd (pairs {:ff "find_files()"
                       :fb "buffers()"
                       :fg "live_grep()"
                       :fc "colorscheme()"
                       :fh "help_tags()"
                       :fd "find_files({cwd='~/dotfiles'})"})]
  (vim.api.nvim_set_keymap :n
                           (.. "<leader>" key)
                           (.. "<cmd>lua require('telescope.builtin')." cmd "<cr>")
                           {:noremap true :silent true}))

;; extensions
(each [_ ext (ipairs [:fzf])]
  (telescope.load_extension ext))
