-- Diff a visual selection against the system clipboard.
-- Zero-dependency: opens the selected lines and the `+` register in two scratch
-- splits in a new tab and runs :diffthis on each.
--
--   <leader>dc  (visual mode)  diff the selection vs clipboard in a new tab
--   :tabclose                  tear the diff down afterwards
--
-- No repo to fetch, so this returns an empty spec and just registers the keymap
-- when lazy.nvim evaluates the file at startup.

local function scratch(open_cmd, lines, name)
  vim.cmd(open_cmd)
  local buf = vim.api.nvim_get_current_buf()
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.api.nvim_buf_set_name(buf, name)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.cmd("diffthis")
end

local function diff_selection_with_clipboard()
  -- Leave visual mode first so '< and '> reflect the current selection.
  vim.cmd("normal! \27")
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  local sel = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local clip = vim.split(vim.fn.getreg("+"), "\n")

  -- Open the diff in its own tab so the original window layout is untouched.
  scratch("tabnew", sel, "[selection]")
  scratch("vnew", clip, "[clipboard]")
end

vim.keymap.set("x", "<leader>dc", function()
  diff_selection_with_clipboard()
end, { desc = "Diff selection with clipboard" })

return {}
