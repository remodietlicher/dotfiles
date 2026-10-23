-- Diff the current buffer against any file on disk, inside or outside the repo.
-- Like the <leader>dc clipboard diff, it opens in its own tab so the original
-- window layout is untouched. The left side is the live buffer, so unsaved
-- changes are part of the diff.
--
--   <leader>df  prompt for a path (prefilled with the buffer's directory,
--               <Tab> completes, ~ and .. work), diff against it in a new tab
--   :tabclose   tear the diff down afterwards
--
-- No repo to fetch, so this returns an empty spec and just registers the keymap
-- when lazy.nvim evaluates the file at startup.

local function diff_buffer_with_file()
  local buf = vim.api.nvim_get_current_buf()
  -- The native input() rather than vim.ui.input: it gives real cmdline file
  -- completion, which is what makes paths outside the cwd practical to type.
  local dir = vim.fn.expand("%:p:~:h")
  local ok, input = pcall(vim.fn.input, {
    prompt = "Diff with: ",
    default = dir ~= "" and dir .. "/" or "",
    completion = "file",
  })
  if not ok or input == "" then
    return -- cancelled with <Esc> / <C-c>
  end

  local file = vim.fn.fnamemodify(vim.fn.expand(input), ":p")
  if vim.fn.filereadable(file) == 0 then
    vim.notify("Not a readable file: " .. input, vim.log.levels.WARN)
    return
  end

  vim.cmd("tab sbuffer " .. buf)
  vim.cmd("diffthis")
  vim.cmd("vert diffsplit " .. vim.fn.fnameescape(file))
end

vim.keymap.set("n", "<leader>df", diff_buffer_with_file, { desc = "Diff buffer with file" })

return {}
