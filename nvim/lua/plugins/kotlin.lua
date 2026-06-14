-- Kotlin LSP via JetBrains' official kotlin-lsp (https://github.com/Kotlin/kotlin-lsp).
--
-- The server is an IntelliJ-IDEA-based language server (Alpha). It ships a
-- `kotlin-lsp` CLI that speaks LSP over stdio. Install the binary and make sure
-- it's on $PATH:
--
--   brew install --cask kotlin-lsp
--
-- NOTE: use the homebrew-cask `kotlin-lsp`, NOT the `JetBrains/utils/kotlin-lsp`
-- tap formula — the tap lags badly and these pre-alpha builds hard-expire on a
-- baked-in date ("This build of intellij-server has expired"), which silently
-- stops the LSP from starting. The cask tracks the latest release.
--
-- nvim-lspconfig ships a built-in `kotlin_lsp` preset, so all we do here is
-- register the server with LazyVim and let it set everything up. The explicit
-- `cmd`/`filetypes`/`root_markers` below mirror that preset so this works even
-- if the pinned lspconfig predates it — drop them once you trust the preset.

return {
  -- 1. LSP: register the kotlin-lsp server. LazyVim feeds `opts.servers` through
  --    nvim-lspconfig / vim.lsp.config, so this enables it for *.kt files.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        kotlin_lsp = {
          cmd = { "kotlin-lsp", "--stdio" },
          filetypes = { "kotlin" },
          -- Anchor the workspace to the build root so multi-module Gradle/Maven
          -- projects resolve correctly (the server is project-, not file-based).
          root_markers = {
            "settings.gradle",
            "settings.gradle.kts",
            "build.gradle",
            "build.gradle.kts",
            "pom.xml",
            ".git",
          },
          -- kotlin-lsp needs a real project; single-file mode is unsupported.
          single_file_support = false,
        },
      },
    },
  },

  -- 2. Highlighting: the kotlin treesitter parser.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "kotlin")
    end,
  },
}
