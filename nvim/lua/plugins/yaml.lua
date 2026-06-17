-- YAML: format with 4-space indent. LazyVim's formatting.prettier extra runs
-- prettier on YAML, and prettier defaults to tabWidth=2. Prettier honors
-- `--tab-width` for YAML, so we inject it via conform's prepend_args.
--
-- The args are filetype-gated so ONLY yaml gets 4 spaces; every other prettier
-- filetype (json, ts, markdown, ...) keeps its 2-space default.
return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters = {
      prettier = {
        prepend_args = function(_, ctx)
          if vim.bo[ctx.buf].filetype == "yaml" then
            return { "--tab-width", "4" }
          end
          return {}
        end,
      },
    },
  },
}
