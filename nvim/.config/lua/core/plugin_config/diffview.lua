require("diffview").setup{}

vim.keymap.set('n', '<leader>gl', ':DiffviewFileHistory<CR>', {})
vim.keymap.set('n', '<leader>gc', ':DiffviewFileHistory %<CR>', {})
vim.keymap.set('n', '<leader>gh', ':DiffviewOpen<CR>', {})
