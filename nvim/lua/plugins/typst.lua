-- Typst: the LazyVim `lang.typst` extra (enabled in lazyvim.json) brings the
-- treesitter parser, the tinymist LSP, typstyle formatting via conform, and
-- chomosuke/typst-preview.nvim. All this file adds is the tooling itself.
--
-- Both binaries come from Mason (its bin dir is on nvim's PATH, which is also
-- how typst-preview.nvim finds tinymist — the extra points its
-- `dependencies_bin` at the PATH `tinymist` instead of auto-downloading one):
--
--   tinymist  — language server *and* compiler; powers completion, diagnostics,
--               goto-definition and the live preview.
--   typstyle  — formatter. tinymist can format too, but the extra sets
--               conform's `lsp_format = "prefer"` so typstyle wins when present.
--
-- The standalone `typst` CLI is NOT needed for editing or preview (tinymist
-- embeds the compiler); install it separately (`brew install typst`) only if you
-- want to compile PDFs from the shell.
--
-- Keymaps from the extra: <leader>cp toggles the live preview (opens in the
-- browser, follows the cursor), <leader>cP pins the current file as the
-- compilation root — use that when editing a chapter that's `#include`d from a
-- main.typ, so diagnostics resolve against the whole document.
return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "tinymist", "typstyle" } },
  },
}
