-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Format the current document (conform + LSP fallback, via LazyVim).
vim.keymap.set({ "n", "v" }, "<leader>af", function()
  LazyVim.format({ force = true })
end, { desc = "Apply format (document)" })

-- Find word in files (live grep). Find files (<leader>ff) and buffers (<leader>fb) are LazyVim defaults.
vim.keymap.set("n", "<leader>fw", "<cmd>FzfLua live_grep<cr>", { desc = "Find word in files" })
