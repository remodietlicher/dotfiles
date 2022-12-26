require("rose-pine").setup({
  dark_variant = "moon",
  highlight_groups = {
    DiffText = { bg = "pine", fg = "gold" },
  },
})

vim.o.termguicolors = true
vim.cmd([[colorscheme rose-pine]])
