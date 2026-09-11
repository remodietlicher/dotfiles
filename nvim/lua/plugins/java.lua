-- Java: format with google-java-format via conform, so <leader>af (and <leader>cf)
-- apply Google Java Style instead of jdtls' stock Eclipse profile.
--
-- LazyVim's format entrypoint runs conform first and only falls back to the LSP
-- (`lsp_format = "fallback"`). The `lang.java` extra registers no conform
-- formatter for java, so without this file formatting silently lands on jdtls.
-- Declaring `formatters_by_ft.java` takes jdtls out of the formatting path.
--
-- google-java-format is Mason-installed (ensure_installed below); conform finds
-- it via Mason's bin on PATH. It's a Java program, so a JDK must be on PATH too
-- (the same one jdtls uses).
--
-- `--aosp` selects the 4-space variant, which also groups imports by top-level
-- package with blank lines and sorts java/javax last. Ubique's projects build on
-- uetlib-spring-boot-starter-parent, which runs spotless with
-- `googleJavaFormat(style=AOSP, reorderImports=true)` at the validate phase --
-- so without this flag every buffer we format gets reverted by the next build.
-- Drop it (or make prepend_args a function of ctx) for Google-style projects.
return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        java = { "google-java-format" },
      },
      formatters = {
        -- conform's builtin is stdin-only (`google-java-format -`), which makes
        -- a visual-mode <leader>af reformat the whole buffer. `--lines` keeps it
        -- to the selection; ctx.range lines are 1-based, as --lines expects.
        -- prepend_args is applied to both args and range_args (see conform's
        -- util.add_formatter_args), so `--aosp` holds for either path.
        ["google-java-format"] = {
          prepend_args = { "--aosp" },
          range_args = function(_, ctx)
            return { "--lines", ctx.range.start[1] .. ":" .. ctx.range["end"][1], "-" }
          end,
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "google-java-format" } },
  },
}
