-- Python: wire ruff into conform for FORMAT (LazyVim's lang.python extra leaves
-- conform's `formatters_by_ft.python` empty on this version, so `:ConformInfo`
-- reports "<none>" and format-on-save / <leader>cf say "no formatter available").
-- ruff itself is Mason-installed; conform finds it via Mason's bin on PATH.
--   ruff_organize_imports — sorts/prunes imports (isort-equivalent)
--   ruff_format           — the actual code formatter (black-equivalent)
-- Tell LazyVim's lang.python extra to use ty instead of pyright.
-- Setting the lsp to a non-existent server prevents it from being Mason-installed.
vim.g.lazyvim_python_lsp = "ty"

return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      python = { "ruff_organize_imports", "ruff_format" },
    },
  },
}
