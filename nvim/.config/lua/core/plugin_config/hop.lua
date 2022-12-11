require('hop').setup { keys = 'fjdkslawueiromv' }
local hop = require('hop')

vim.keymap.set({'n', 'v'}, '<leader>d', ':HopWordMW<CR>')
vim.keymap.set({'n', 'v'}, '<leader>s', ':HopLineMW<CR>')

vim.keymap.set('', '<leader>d', function() hop.hint_words() end, {remap=true})
vim.keymap.set('', '<leader>s', function() hop.hint_lines({ multi_windows=true }) end, {remap=true})
vim.keymap.set('', '<leader>a', function() hop.hint_char1() end, {remap=true})
