-- tpope/vim-surround-style mappings (ds, cs, ys) via the Lua reimplementation.
-- LazyVim ships no surround plugin by default (mini.surround is an opt-in extra
-- and uses gs-prefixed keys, not ds'/cs'). nvim-surround defaults to the
-- classic mappings: ds' (delete surrounding '), cs'" (change ' to "),
-- ysiw( (surround word with parens), yss) (whole line), visual S.
return {
  "kylechui/nvim-surround",
  version = "*",
  event = "VeryLazy",
  opts = {},
}
