-- Just bootstrapping fennel :)
local os = require('os')
package.path = package.path .. ';' .. os.getenv('HOME') .. '/code/Fennel/?.lua'

-- TODO: alternativey, could have an autocommand run that compiles fennel to
-- lua on save

local fennel = require("fennel")

-- TODO: this only works with package.path, not nvim's runtimepath
-- table.insert(package.loaders or package.searchers, fennel.searcher)

-- Nvim adds its own loader to search for lua packages on runtimepath.
-- Here's a loader to do the same, but for fennel packages
-- TODO: might need to add something like this for macros
table.insert(package.loaders or package.searchers, function(name)
	-- Based on https://github.com/neovim/neovim/blob/f5fb79733e30b6444e9637e9a1aa4bfcb2050ab5/src/nvim/lua/vim.lua#L57
	local basename = name:gsub('%.', '/')
  local paths = {"fnl/"..basename..".fnl", "fnl/"..basename.."/init.fnl"}
  local found = vim.api.nvim__get_runtime(paths, false, {})
  if #found > 0 then
    return function()
      return fennel.dofile(found[1])
    end
  end
end)

-- reload init-fnl
package.loaded['init-fnl'] = nil
require('init-fnl')
