-- Declutter markdown: hide inline (virtual text) diagnostics for markdown buffers
-- while keeping sign-column markers, underlines, and hover (K) details intact.
-- Other filetypes keep LazyVim's default virtual-text styling.
return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.diagnostics = opts.diagnostics or {}
    local default_vt = opts.diagnostics.virtual_text
    opts.diagnostics.virtual_text = function(_, bufnr)
      if vim.bo[bufnr].filetype == "markdown" then
        return false
      end
      return default_vt
    end
  end,
}
