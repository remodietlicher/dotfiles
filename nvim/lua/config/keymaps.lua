-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Format the current document (conform + LSP fallback, via LazyVim).
vim.keymap.set({ "n", "v" }, "<leader>af", function()
  LazyVim.format({ force = true })
end, { desc = "Apply format (document)" })

-- Find word in files (live grep). Find files (<leader>ff) and buffers (<leader>fb) are LazyVim defaults.
vim.keymap.set("n", "<leader>fw", "<cmd>FzfLua live_grep<cr>", { desc = "Find word in files" })

-- Yank the current buffer's name to the system clipboard. The filename-modifier
-- picks what you get: `%:p` the absolute path, `%:t` the tail (name + extension).
-- Append `:r` to either to drop the extension, e.g. `%:t:r`. Unnamed buffers
-- (scratch, pickers) expand to "", so warn instead of clobbering the clipboard.
local function yank_filename(modifier)
  return function()
    local name = vim.fn.expand("%" .. modifier)
    if name == "" then
      vim.notify("Buffer has no file name", vim.log.levels.WARN)
      return
    end
    vim.fn.setreg("+", name)
    vim.notify("Copied: " .. name)
  end
end

vim.keymap.set("n", "<leader>yp", yank_filename(":p"), { desc = "Yank absolute file path" })
vim.keymap.set("n", "<leader>yn", yank_filename(":t"), { desc = "Yank file name" })

-- Scroll the viewport 5 lines with Option/Alt + j/k (aligned with motion: j = down, k = up).
-- This intentionally overrides LazyVim's default <A-j>/<A-k> move-lines binding (dropped).
vim.keymap.set({ "n", "v" }, "<A-j>", "5<C-e>", { desc = "Scroll down 5 lines" })
vim.keymap.set({ "n", "v" }, "<A-k>", "5<C-y>", { desc = "Scroll up 5 lines" })
-- Also clear the insert-mode move-lines default so Option+j/k is purely scroll everywhere.
vim.keymap.set("i", "<A-j>", "<Nop>")
vim.keymap.set("i", "<A-k>", "<Nop>")

-- Disable the default single-line scroll keys (unwanted).
vim.keymap.set({ "n", "v" }, "<C-e>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<C-y>", "<Nop>")

-- Exit insert mode with `jj`.
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Option+Delete deletes the word before the cursor (macOS muscle memory).
-- Ghostty maps the LEFT Option key as Alt (macos-option-as-alt = left), so
-- left-Option+Backspace arrives here as <M-BS>; <C-w> is the built-in that
-- deletes the preceding word. Wired for insert and command-line modes.
vim.keymap.set({ "i", "c" }, "<M-BS>", "<C-w>", { desc = "Delete word before cursor" })

-- Close the current buffer with Cmd+W (the macOS "close tab" muscle memory),
-- keeping the window/split layout intact. Ghostty translates Cmd+W into the
-- kitty-protocol Super+w sequence (ESC [ 119 ; 9 u), which travels through tmux
-- untouched and arrives here as <D-w>. See ghostty/config for the terminal side.
vim.keymap.set({ "n", "i", "v" }, "<D-w>", function()
  Snacks.bufdelete()
end, { desc = "Close buffer" })

-- Show the repo's recent GitHub Actions runs (`gh run list`, running ones on
-- top) in a float. auto_close = false keeps the output after gh exits; `q`
-- closes it. Runs from the git root so gh finds the remote.
vim.keymap.set("n", "<leader>gA", function()
  Snacks.terminal({ "gh", "run", "list", "-L", "15" }, { cwd = LazyVim.root.git(), auto_close = false })
end, { desc = "GitHub Actions runs" })

-- Move tab switching from LazyVim's default <leader><tab>[ / <leader><tab>]
-- to <leader><tab>p / <leader><tab>n (previous/next, mnemonic over bracket).
vim.keymap.del("n", "<leader><tab>[")
vim.keymap.del("n", "<leader><tab>]")
vim.keymap.set("n", "<leader><tab>p", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
vim.keymap.set("n", "<leader><tab>n", "<cmd>tabnext<cr>", { desc = "Next Tab" })
