vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.backspace = "2"
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.spelllang = "en"
vim.opt.clipboard = "unnamedplus"

-- use spaces for tabs and whatnot
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true

-- search
-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "No search highlight" })

-- custom esc
vim.keymap.set("i", "jj", "<esc>", {desc = "Remap ESC key"})

-- pane management
vim.keymap.set("n", "<leader>sl", ":vsplit<CR>", { desc = "Split pane vertically" })
vim.keymap.set("n", "<leader>sk", ":split<CR>", { desc = "Split pane horizontally" })
vim.keymap.set("n", "<c-h>", "<c-w>h", { desc = "Move pane left" })
vim.keymap.set("n", "<c-j>", "<c-w>j", { desc = "Move pane down" })
vim.keymap.set("n", "<c-k>", "<c-w>k", { desc = "Move pane up" })
vim.keymap.set("n", "<c-l>", "<c-w>l", { desc = "Move pane right" })

-- navigation
vim.keymap.set("n", "<a-left>", "<c-O>", { desc = "Go back" })
vim.keymap.set("n", "<a-right>", "<c-I>", { desc = "Go forward" })
vim.keymap.set("n", "<a-k>", ":bp<CR>", { desc = "Open previous buffer" })
vim.keymap.set("n", "<a-j>", ":bn<CR>", { desc = "Open next buffer" })

-- useful shortcuts
vim.keymap.set("v", "<leader>p", '"_dP', { desc = "Put text from visual selection into _ registry" })
vim.keymap.set("v", "<c-c>", '"+y', { desc = "Yank to system clipboard" })

-- yanking filename (very useful for markdown links!)
vim.keymap.set(
  "n",
  "<leader>yr",
  ":let @+ = expand('%')<CR>",
  { desc = "[Y]ank [R]elative file name to unnamed register" }
)
vim.keymap.set(
  "n",
  "<leader>ya",
  ":let @+ = expand('%:p')<CR>",
  { desc = "[Y]ank [A]bsolute file name to unnamed register" }
)
vim.keymap.set(
  "n",
  "<leader>yf",
  ":let @+ = expand('%:t')<CR>",
  { desc = "[Y]ank [F]ile name to unnamed register" }
)

-- toggle normal mode in terminal mode
vim.keymap.set("t", "<c-n>", "<c-\\><c-n>", { desc = "Enter [N]ormal mode in terminal" })
