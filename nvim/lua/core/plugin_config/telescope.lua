require("telescope").setup()
require("telescope").load_extension("fzf")

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]ile" })
vim.keymap.set("n", "<leader>fw", function()
  builtin.grep_string({ search = "", only_sort_text = true })
end, { desc = "[F]ind [W]ord" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fb", function()
  builtin.buffers({ sort_mru = true })
end, { desc = "[F]ind [B]uffer" })
vim.keymap.set("n", "<leader>/", function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer]" })
vim.keymap.set("n", "<leader>fs", builtin.treesitter, { desc = "[F]ind [S]ymbol (from treesitter)" })
