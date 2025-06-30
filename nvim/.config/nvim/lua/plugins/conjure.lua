-- [nfnl] fnl/plugins/conjure.fnl
local function _1_()
  vim.g["conjure#client_on_load"] = false
  vim.g["conjure#mapping#doc_word"] = "k"
  vim.g["conjure#mapping#eval_current_form"] = {"cpp"}
  vim.g["conjure#mapping#eval_word"] = {"cww"}
  vim.g["conjure#mapping#eval_marked_form"] = {"cm"}
  vim.g["conjure#mapping#eval_motion"] = {"cp"}
  vim.g["conjure#mapping#eval_root_form"] = {"cp-"}
  vim.g["conjure#mapping#def_word"] = "d"
  return nil
end
return {"Olical/conjure", ft = {"clojure", "fennel", "python"}, lazy = true, init = _1_}
