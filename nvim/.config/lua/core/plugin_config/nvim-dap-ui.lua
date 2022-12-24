local dapui = require("dapui")
dapui.setup()

vim.keymap.set("n", "<leader>mo", dapui.open, {})
vim.keymap.set("n", "<leader>mc", dapui.close, {})
