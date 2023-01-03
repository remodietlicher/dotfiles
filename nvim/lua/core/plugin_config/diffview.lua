require("diffview").setup({})

vim.keymap.set("n", "<leader>vl", ":DiffviewFileHistory<CR>", { desc = "Diff[V]iew show git [L]og" })
vim.keymap.set("n", "<leader>vf", ":DiffviewFileHistory %<CR>", { desc = "Diff[V]iew current [F]ile history" })
vim.keymap.set("n", "<leader>vo", ":DiffviewOpen<CR>", { desc = "Diff[V]iew [O]pen" })
vim.keymap.set("n", "<leader>vc", ":DiffviewClose<CR>", { desc = "Diff[V]iew [C]lose" })
vim.keymap.set("n", "<leader>vr", ":DiffviewRefresh<CR>", { desc = "Diff[V]iew [R]efresh" })
