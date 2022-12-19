require('telescope').setup()
require('telescope').load_extension('fzf')

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<c-p>', builtin.find_files, {})
vim.keymap.set('n', '<c-F>', function() builtin.grep_string({search = '', only_sort_text = true}) end, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
