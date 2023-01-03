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

-- pane management
vim.keymap.set("n", "<c-L>", ":vsplit<CR>", { desc = "Split pane vertically" })
vim.keymap.set("n", "<c-K>", ":split<CR>", { desc = "Split pane horizontally" })
vim.keymap.set("n", "<c-h>", "<c-w>h", { desc = "Move pane left" })
vim.keymap.set("n", "<c-j>", "<c-w>j", { desc = "Move pane down" })
vim.keymap.set("n", "<c-k>", "<c-w>k", { desc = "Move pane up" })
vim.keymap.set("n", "<c-l>", "<c-w>l", { desc = "Move pane right" })

-- navigation
vim.keymap.set("n", "<a-left>", "<c-O>", { desc = "Go back" })
vim.keymap.set("n", "<a-right>", "<c-I>", { desc = "Go forward" })

-- put the paste registry to garbage
vim.keymap.set("v", "<leader>p", '"_dP', { desc = "Put text from visual selection into _ registry" })

-- toggle normal mode in terminal mode
vim.keymap.set("t", "<c-n>", "<c-\\><c-n>", { desc = "Enter [N]ormal mode in terminal" })
