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
      ".env",
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

    -- Same treatment for live_grep (<leader>fw): --hidden pulls in .github/ etc.,
    -- --no-ignore searches gitignored files, and the globs keep noise dirs out.
    -- `-e` must stay last: fzf-lua appends the search pattern after rg_opts.
    opts.grep = vim.tbl_extend("force", opts.grep or {}, {
      rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden --no-ignore "
        .. table.concat(rg_globs, " ")
        .. " -e",
    })
    return opts
  end,
}
