-- dbt: SQL + Jinja highlighting, with sqlfmt for FORMAT and sqlfluff for LINT.
--
-- Why two tools: sqlfluff must fully PARSE a statement to reindent it, and its
-- clickhouse dialect can't parse some intentional CH syntax in this repo
-- (`interval` as a column name, `{name:Type}` server-side params) — so it
-- silently leaves those statements' layout untouched (over-indentation never
-- gets fixed). sqlfmt formats from token structure (dialect-agnostic), so it
-- reindents every model. sqlfluff stays as the linter (rule violations), which
-- is its strength.
--
-- Install both:
--   uv tool install "shandy-sqlfmt[jinjafmt]"
--   uv tool install sqlfluff --with sqlfluff-templater-dbt
--
-- sqlfmt: `--dialect clickhouse` is required — the default `polyglot` dialect
-- LOWERCASES unquoted identifiers, which would corrupt case-sensitive ClickHouse
-- columns (appId -> appid). The clickhouse dialect preserves them.
--
-- sqlfluff (lint) needs a `.sqlfluff` config at the REPO ROOT (not dbt/): both
-- conform and nvim-lint run from there, and nvim-lint has no root-detection so
-- it runs sqlfluff from Neovim's cwd. Editor-friendly config:
--
--   [sqlfluff]
--   templater = jinja          # `dbt` templater can't resolve ref() over stdin
--   dialect = clickhouse
--   ignore = parsing           # tolerate the CH syntax sqlfluff can't parse
--   [sqlfluff:templater:jinja]
--   load_macros_from_path = dbt/macros

return {
  -- 1. Highlighting: load SQL + Jinja syntax together via the compound
  --    `jinja.sql` filetype for dbt model/macro files.
  {
    "Glench/Vim-Jinja2-Syntax",
    init = function()
      vim.filetype.add({
        pattern = {
          [".*/models/.*%.sql"] = "jinja.sql",
          [".*/macros/.*%.sql"] = "jinja.sql",
          [".*/tests/.*%.sql"] = "jinja.sql",
          [".*/analyses/.*%.sql"] = "jinja.sql",
          [".*/snapshots/.*%.sql"] = "jinja.sql",
        },
      })
    end,
  },

  -- 2. Format with sqlfmt (conform is LazyVim's formatter manager). Keyed under
  --    both `sql` and `jinja.sql`; conform splits compound filetypes on `.`, so
  --    the `sql` key alone would also match, but being explicit is harmless.
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sql = { "sqlfmt" },
        ["jinja.sql"] = { "sqlfmt" },
      },
      formatters = {
        -- conform's built-in sqlfmt is `sqlfmt -`; add the clickhouse dialect so
        -- case-sensitive identifiers (appId, osVersion) are preserved rather
        -- than lowercased by the default polyglot dialect.
        sqlfmt = { args = { "--dialect", "clickhouse", "-" } },
      },
    },
  },

  -- 3. Lint with sqlfluff (nvim-lint is LazyVim's linter manager).
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        sql = { "sqlfluff" },
        ["jinja.sql"] = { "sqlfluff" },
      },
    },
  },
}
