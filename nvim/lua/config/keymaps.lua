-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Format the current document (conform + LSP fallback, via LazyVim).
vim.keymap.set({ "n", "v" }, "<leader>af", function()
  LazyVim.format({ force = true })
end, { desc = "Apply format (document)" })

-- Find word in files (live grep). Find files (<leader>ff) and buffers (<leader>fb) are LazyVim defaults.
vim.keymap.set("n", "<leader>fw", "<cmd>FzfLua live_grep<cr>", { desc = "Find word in files" })

-- Yank the absolute path of the current file to the system clipboard.
vim.keymap.set("n", "<leader>yp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Yank absolute file path" })

-- Scroll the viewport 5 lines with Option/Alt + j/k (aligned with motion: j = down, k = up).
-- This intentionally overrides LazyVim's default <A-j>/<A-k> move-lines binding (dropped).
vim.keymap.set({ "n", "v" }, "<A-j>", "5<C-e>", { desc = "Scroll down 5 lines" })
vim.keymap.set({ "n", "v" }, "<A-k>", "5<C-y>", { desc = "Scroll up 5 lines" })
-- Also clear the insert-mode move-lines default so Option+j/k is purely scroll everywhere.
vim.keymap.set("i", "<A-j>", "<Nop>")
vim.keymap.set("i", "<A-k>", "<Nop>")

-- Disable the default single-line scroll keys (unwanted).
vim.keymap.set({ "n", "v" }, "<C-e>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<C-y>", "<Nop>")

-- Exit insert mode with `jj`.
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Option+Delete deletes the word before the cursor (macOS muscle memory).
-- Ghostty maps the LEFT Option key as Alt (macos-option-as-alt = left), so
-- left-Option+Backspace arrives here as <M-BS>; <C-w> is the built-in that
-- deletes the preceding word. Wired for insert and command-line modes.
vim.keymap.set({ "i", "c" }, "<M-BS>", "<C-w>", { desc = "Delete word before cursor" })

-- Close the current buffer with Cmd+W (the macOS "close tab" muscle memory),
-- keeping the window/split layout intact. Ghostty translates Cmd+W into the
-- kitty-protocol Super+w sequence (ESC [ 119 ; 9 u), which travels through tmux
-- untouched and arrives here as <D-w>. See ghostty/config for the terminal side.
vim.keymap.set({ "n", "i", "v" }, "<D-w>", function()
  Snacks.bufdelete()
end, { desc = "Close buffer" })

-- Move tab switching from LazyVim's default <leader><tab>[ / <leader><tab>]
-- to <leader><tab>p / <leader><tab>n (previous/next, mnemonic over bracket).
vim.keymap.del("n", "<leader><tab>[")
vim.keymap.del("n", "<leader><tab>]")
vim.keymap.set("n", "<leader><tab>p", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
vim.keymap.set("n", "<leader><tab>n", "<cmd>tabnext<cr>", { desc = "Next Tab" })
