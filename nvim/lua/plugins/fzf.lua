-- fzf-lua: make the file pickers (<leader>ff etc.) show ALL files —
--   --hidden     -> dotfiles like .gitignore, .vscode/...
--   --no-ignore  -> gitignored files like .vscode/launch.json
-- The default fd/rg opts skip both. Because --no-ignore also drags in build and
-- cache dirs that are normally gitignored, we explicitly exclude the common ones
-- below — edit the `ignore` list to taste.
--
-- You can still toggle ignore live inside the picker (alt-i).
--
-- `optional = true` => only extend the fzf-lua spec the editor.fzf extra adds.
return {
  "ibhagwan/fzf-lua",
  optional = true,
  opts = function(_, opts)
    -- Dirs kept out of the file pickers even with --no-ignore enabled.
    local ignore = {
      ".git",
      ".jj",
      "node_modules",
      ".venv",
      "venv",
      "__pycache__",
      ".mypy_cache",
      ".pytest_cache",
      ".ruff_cache",
      "target", -- rust
      "dist",
      "build",
      ".next",
    }

    local fd_excludes, rg_globs = {}, {}
    for _, dir in ipairs(ignore) do
      table.insert(fd_excludes, "--exclude " .. dir)
      table.insert(rg_globs, ([[-g "!%s"]]):format(dir))
    end

    opts.files = vim.tbl_extend("force", opts.files or {}, {
      fd_opts = "--color=never --type f --type l --hidden --no-ignore " .. table.concat(fd_excludes, " "),
      rg_opts = "--color=never --files --hidden --no-ignore " .. table.concat(rg_globs, " "),
    })
    return opts
  end,
}
