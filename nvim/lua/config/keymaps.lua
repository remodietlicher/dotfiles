-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Format the current document (conform + LSP fallback, via LazyVim).
vim.keymap.set({ "n", "v" }, "<leader>af", function()
  LazyVim.format({ force = true })
end, { desc = "Apply format (document)" })

-- Find word in files (live grep). Find files (<leader>ff) and buffers (<leader>fb) are LazyVim defaults.
vim.keymap.set("n", "<leader>fw", "<cmd>FzfLua live_grep<cr>", { desc = "Find word in files" })

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
