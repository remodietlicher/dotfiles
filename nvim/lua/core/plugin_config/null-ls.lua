local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.clang_format,
    null_ls.builtins.formatting.cmake_format,
    null_ls.builtins.formatting.rustfmt,
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.diagnostics.cpplint,
  },
})

vim.keymap.set("n", "<leader>af", vim.lsp.buf.format, { desc = "[A]pply [F]ormat" })
