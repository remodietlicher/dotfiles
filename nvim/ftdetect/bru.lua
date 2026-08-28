-- Bruno (https://usebruno.com) request files. Neovim has no built-in detection
-- for `.bru`, and there is no tree-sitter grammar for it either, so this pairs
-- with the hand-written `syntax/bru.vim`.
vim.filetype.add({ extension = { bru = "bru" } })
