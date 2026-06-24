-- Python: wire ruff into conform for FORMAT (LazyVim's lang.python extra leaves
-- conform's `formatters_by_ft.python` empty on this version, so `:ConformInfo`
-- reports "<none>" and format-on-save / <leader>cf say "no formatter available").
-- ruff itself is Mason-installed; conform finds it via Mason's bin on PATH.
--   ruff_organize_imports — sorts/prunes imports (isort-equivalent)
--   ruff_format           — the actual code formatter (black-equivalent)
-- Tell LazyVim's lang.python extra to use ty instead of pyright.
-- Setting the lsp to a non-existent server prevents it from being Mason-installed.
vim.g.lazyvim_python_lsp = "ty"

-- uv workspace root fix: both ty and ruff default to stopping at the nearest
-- pyproject.toml (the workspace member). Putting uv.lock first makes them climb
-- to the actual workspace root, which also fixes <leader>ff via LazyVim.root().
local python_root_markers = { "uv.lock", ".git", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt" }

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ty = { root_markers = python_root_markers },
        ruff = { root_markers = python_root_markers },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_format" },
      },
    },
  },
}
