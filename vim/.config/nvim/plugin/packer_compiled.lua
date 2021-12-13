-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/mike/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/mike/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/mike/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/mike/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/mike/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["base16-vim"] = {
    loaded = true,
    path = "/home/mike/.local/share/nvim/site/pack/packer/start/base16-vim",
    url = "https://github.com/chriskempson/base16-vim"
  },
  ["gv.vim"] = {
    loaded = true,
    path = "/home/mike/.local/share/nvim/site/pack/packer/start/gv.vim",
    url = "https://github.com/junegunn/gv.vim"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\1\2-\0\0\2\0\2\0\0034\0\0\0%\1\1\0@\0\2\0\22config.treesitter\frequire\0" },
    loaded = true,
    path = "/home/mike/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/mike/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["pgsql.vim"] = {
    config = { "\27LJ\1\2<\0\0\2\0\4\0\0064\0\0\0007\0\1\0%\1\3\0:\1\2\0)\0\0\0H\0\2\0\npgsql\21sql_type_default\6g\bvim\0" },
    loaded = true,
    path = "/home/mike/.local/share/nvim/site/pack/packer/start/pgsql.vim",
    url = "https://github.com/lifepillar/pgsql.vim"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/home/mike/.local/share/nvim/site/pack/packer/start/vim-commentary",
    url = "https://github.com/tpope/vim-commentary"
  },
  ["vim-dadbod"] = {
    loaded = true,
    path = "/home/mike/.local/share/nvim/site/pack/packer/start/vim-dadbod",
    url = "https://github.com/tpope/vim-dadbod"
  },
  ["vim-eunuch"] = {
    loaded = true,
    path = "/home/mike/.local/share/nvim/site/pack/packer/start/vim-eunuch",
    url = "https://github.com/tpope/vim-eunuch"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/mike/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-polyglot"] = {
    loaded = true,
    needs_bufread = true,
    path = "/home/mike/.local/share/nvim/site/pack/packer/opt/vim-polyglot",
    url = "https://github.com/sheerun/vim-polyglot"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/mike/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-rhubarb"] = {
    loaded = true,
    path = "/home/mike/.local/share/nvim/site/pack/packer/start/vim-rhubarb",
    url = "https://github.com/tpope/vim-rhubarb"
  },
  ["vim-rsi"] = {
    loaded = true,
    path = "/home/mike/.local/share/nvim/site/pack/packer/start/vim-rsi",
    url = "https://github.com/tpope/vim-rsi"
  },
  ["vim-sensible"] = {
    loaded = true,
    path = "/home/mike/.local/share/nvim/site/pack/packer/start/vim-sensible",
    url = "https://github.com/tpope/vim-sensible"
  },
  ["vim-sexp"] = {
    loaded = true,
    path = "/home/mike/.local/share/nvim/site/pack/packer/start/vim-sexp",
    url = "https://github.com/guns/vim-sexp"
  },
  ["vim-sexp-mappings-for-regular-people"] = {
    loaded = true,
    path = "/home/mike/.local/share/nvim/site/pack/packer/start/vim-sexp-mappings-for-regular-people",
    url = "https://github.com/tpope/vim-sexp-mappings-for-regular-people"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/mike/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "/home/mike/.local/share/nvim/site/pack/packer/start/vim-unimpaired",
    url = "https://github.com/tpope/vim-unimpaired"
  }
}

time([[Defining packer_plugins]], false)
-- Setup for: vim-polyglot
time([[Setup for vim-polyglot]], true)
try_loadstring("\27LJ\1\2?\0\0\2\0\4\0\0064\0\0\0007\0\1\0003\1\3\0:\1\2\0)\0\0\0H\0\2\0\1\2\0\0\bsql\22polyglot_disabled\6g\bvim\0", "setup", "vim-polyglot")
time([[Setup for vim-polyglot]], false)
time([[packadd for vim-polyglot]], true)
vim.cmd [[packadd vim-polyglot]]
time([[packadd for vim-polyglot]], false)
-- Config for: pgsql.vim
time([[Config for pgsql.vim]], true)
try_loadstring("\27LJ\1\2<\0\0\2\0\4\0\0064\0\0\0007\0\1\0%\1\3\0:\1\2\0)\0\0\0H\0\2\0\npgsql\21sql_type_default\6g\bvim\0", "config", "pgsql.vim")
time([[Config for pgsql.vim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\1\2-\0\0\2\0\2\0\0034\0\0\0%\1\1\0@\0\2\0\22config.treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
