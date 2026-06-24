-- Smart `gd`: behave like an IDE — jump to the definition when the cursor is on
-- a usage, and list references when the cursor is already on the definition.
--
-- How it decides: fire a raw `textDocument/definition` request and compare the
-- returned location against the cursor. If the definition's range *contains* the
-- cursor, we're sitting on the definition itself -> show references. Otherwise
-- it's a usage -> jump to the definition. Both branches reuse the Snacks picker
-- so the UX matches the rest of LazyVim's LSP keymaps.

local function smart_goto()
  local bufnr = 0
  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/definition" })
  if #clients == 0 then
    return Snacks.picker.lsp_definitions()
  end

  local enc = clients[1].offset_encoding or "utf-16"
  local params = vim.lsp.util.make_position_params(0, enc)

  vim.lsp.buf_request(bufnr, "textDocument/definition", params, function(err, result)
    if err or not result or (type(result) == "table" and vim.tbl_isempty(result)) then
      return Snacks.picker.lsp_definitions()
    end

    local locations = vim.islist(result) and result or { result }
    local cur_uri = vim.uri_from_bufnr(bufnr)
    local cur_line = vim.api.nvim_win_get_cursor(0)[1] - 1 -- 0-based to match LSP ranges

    local on_definition = false
    for _, loc in ipairs(locations) do
      local uri = loc.uri or loc.targetUri
      local range = loc.range or loc.targetSelectionRange
      if uri == cur_uri and range and cur_line >= range.start.line and cur_line <= range["end"].line then
        on_definition = true
        break
      end
    end

    if on_definition then
      Snacks.picker.lsp_references()
    else
      Snacks.picker.lsp_definitions()
    end
  end)
end

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ty = {},
      -- `["*"]` applies to every server. Re-defining "gd" overrides LazyVim's
      -- default because the keymap resolver lets the last entry for an lhs win.
      ["*"] = {
        keys = {
          { "gd", smart_goto, desc = "Goto Definition / References (smart)", has = "definition" },
        },
      },
    },
  },
}
