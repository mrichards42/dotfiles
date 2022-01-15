-- TODO: alternatively, could have an autocommand run that compiles fennel to
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

function _G.fennel_pprint(...)
  local t = {}
  for i = 1, select("#", ...) do
    local x = select(i, ...)
    t[i] = fennel.view(x)
  end
  print(unpack(t))
end

function _G.require_bang(name)
  package.loaded[name] = nil
  return require(name)
end

-- For fennel, `require!` is a bit more lispy
_G['require!'] = _G['require_bang']
