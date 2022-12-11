require('telescope').setup()
require('telescope').load_extension('fzf')

vim.keymap.set('n', '<c-p>', ':Telescope find_files<CR>', {})
vim.keymap.set('n', '<c-F>', ':Telescope grep_string search="" <CR>', {})
vim.keymap.set('n', '<leader>fh', ':Telescope help_tags<CR>', {})
