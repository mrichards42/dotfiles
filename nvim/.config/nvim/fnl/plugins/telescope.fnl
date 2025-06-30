{1 "nvim-telescope/telescope.nvim"
 :branch "0.1.x"
 :dependencies ["nvim-lua/plenary.nvim"
                {1 "nvim-telescope/telescope-fzf-native.nvim"
                 :build "make"
                 :config #(let [telescope (require :telescope)]
                            (telescope.load_extension :fzf))}]
 :cmd "Telescope"
 :opts {:defaults {:mappings {:i {"<esc>" "close"}}}
        :pickers {:colorscheme {:theme "dropdown"
                                :enable_preview true}
                  :find_files {:hidden true}}}
 :keys [["<leader>ff" "<cmd>Telescope find_files<CR>"]
        ["<leader>fd" "<cmd>Telescope find_files cwd=~/dotfiles<CR>"]
        ["<leader>fb"
         "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<CR>"]
        ["<leader>fg" #((. (require :telescope.builtin) :live_grep) {:additional_args ["--hidden"]})]
        ["<leader>fh" "<cmd>Telescope help_tags<CR>"]
        ["<leader>fc" "<cmd>Telescope commands<CR>"]]}
