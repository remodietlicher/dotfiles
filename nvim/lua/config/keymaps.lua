-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Format the current document (conform + LSP fallback, via LazyVim).
vim.keymap.set({ "n", "v" }, "<leader>af", function()
  LazyVim.format({ force = true })
end, { desc = "Apply format (document)" })

-- Find word in files (live grep). Find files (<leader>ff) and buffers (<leader>fb) are LazyVim defaults.
vim.keymap.set("n", "<leader>fw", "<cmd>FzfLua live_grep<cr>", { desc = "Find word in files" })

-- Scroll the viewport 5 lines up/down. Note: <C-i> is the same keycode as <Tab> in a
-- terminal, so this also rebinds Tab in normal mode and shadows the jumplist-forward jump.
vim.keymap.set({ "n", "v" }, "<C-u>", "5<C-y>", { desc = "Scroll up 5 lines" })
vim.keymap.set({ "n", "v" }, "<C-i>", "5<C-e>", { desc = "Scroll down 5 lines" })

-- Disable the default single-line scroll keys (unwanted).
vim.keymap.set({ "n", "v" }, "<C-e>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<C-y>", "<Nop>")
