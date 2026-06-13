-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Auto-save (PyCharm-like): debounced save shortly after edits, immediate save on focus/buffer loss.
-- Only ever touches real, modified, writable, named file buffers; uses `update` so format-on-save still runs.
local autosave = vim.api.nvim_create_augroup("user_autosave", { clear = true })

local function should_save(buf)
  return vim.bo[buf].buftype == "" -- normal file buffer (not terminal/help/prompt/etc.)
    and vim.bo[buf].modifiable
    and not vim.bo[buf].readonly
    and vim.bo[buf].modified
    and vim.api.nvim_buf_get_name(buf) ~= "" -- has a filename on disk
end

local function save(buf)
  if vim.api.nvim_buf_is_valid(buf) and should_save(buf) then
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("silent! lockmarks update")
    end)
  end
end

-- Debounce: only save ~1s after the last change, so it doesn't fire on every keystroke.
local timer
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = autosave,
  callback = function(ev)
    if timer then
      timer:stop()
    end
    timer = vim.defer_fn(function()
      save(ev.buf)
    end, 1000)
  end,
})

-- Save immediately when leaving the buffer or when nvim loses focus (e.g. switching tmux pane / window).
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  group = autosave,
  callback = function(ev)
    save(ev.buf)
  end,
})
