-- Database client (DataGrip replacement): vim-dadbod + UI + completion.
--
-- Modelled on LazyVim's `lang.sql` extra, minus its Mason-installed sqlfluff and
-- conform/nvim-lint wiring: SQL formatting and linting live in dbt.lua (sqlfmt +
-- the uv-installed sqlfluff), and a Mason sqlfluff would shadow that one on PATH.
--
-- dadbod shells out to each database's own CLI, so the matching client must be
-- on PATH: psql, mysql, sqlite3, duckdb, `clickhouse` (client), ...
--
-- Connections. This repo is public, so no URLs here. Pick one of:
--   * `A` in the DBUI drawer (or :DBUIAddConnection): saved to
--     stdpath("data")/dadbod_ui/connections.json, available everywhere.
--   * $DBUI_URL (+ optional $DBUI_NAME) exported from ~/.zshrc.local.
--   * A per-project `.lazy.lua` (git-ignored) that sets
--       vim.g.dbs = { { name = "dev", url = "postgres://..." } }
--       return {}
--   URLs can pull secrets at runtime instead of storing them, e.g.
--     url = function() return vim.fn.system("op read op://vault/db/url"):gsub("%s+$", "") end
--
-- Usage: <leader>Du opens the drawer; pick a connection, `<CR>` on a table's
-- helper (List, Columns, Indexes, ...) runs it; `<CR>` on "New query" opens a
-- scratch buffer bound to that DB. In a query buffer:
--   <leader>S    run whole buffer (normal) / selection (visual)   [dbui default]
--   <leader>Dr   run the statement under cursor (paragraph)       [like Cmd+Enter in DataGrip]
--   <leader>W    save query to the connection's saved queries      [dbui default]
--   <leader>E    edit bind parameters                              [dbui default]
-- Results open in a `dbout` split; `<C-]>` on a foreign-key value jumps to the row.

local sql_ft = { "sql", "mysql", "plsql" }

-- Neovim's bundled sql_completion fights blink's omni source; keep only its
-- syntax keywords (same as LazyVim's extra).
vim.g.omni_sql_default_compl_type = "syntax"
vim.g.loaded_sql_completion = true
-- ...and drop ftplugin/sql.vim's insert-mode maps into it (<Left>/<Right>,
-- <C-c>a, <C-c>t, ...). With sqlcomplete not loaded they'd call missing
-- functions: "E117: Unknown function: sqlcomplete#DrillOutOfColumns".
vim.g.omni_sql_no_default_maps = 1

return {
  { "tpope/vim-dadbod", cmd = "DB" },

  {
    "kristijanhusak/vim-dadbod-ui",
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    dependencies = { "tpope/vim-dadbod" },
    keys = {
      { "<leader>D", "", desc = "+database" },
      -- DB UI lives in its own tab page, like a DataGrip window: opens it the
      -- first time, jumps to it from elsewhere, and jumps back from inside it.
      {
        "<leader>Du",
        function()
          for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
              if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "dbui" then
                if tab == vim.api.nvim_get_current_tabpage() then
                  if not pcall(vim.cmd, "tabnext #") then
                    vim.cmd("tabprevious")
                  end
                else
                  vim.api.nvim_set_current_tabpage(tab)
                end
                return
              end
            end
          end
          vim.cmd("tab DBUI")
        end,
        desc = "DB UI (tab)",
      },
      { "<leader>Da", "<cmd>DBUIAddConnection<cr>", desc = "Add connection" },
      { "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Attach buffer to DB" },
      { "<leader>Dl", "<cmd>DBUILastQueryInfo<cr>", desc = "Last query info" },
      {
        "<leader>Dr",
        "vip<Plug>(DBUI_ExecuteQuery)",
        remap = true,
        ft = sql_ft,
        desc = "Run statement under cursor",
      },
    },
    init = function()
      local data_path = vim.fn.stdpath("data")
      vim.g.db_ui_save_location = data_path .. "/dadbod_ui"
      vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_use_nvim_notify = 1
      vim.g.db_ui_winwidth = 40
      -- Run a table helper (List, Columns, ...) as soon as it's opened, like
      -- double-clicking a table in DataGrip.
      vim.g.db_ui_auto_execute_table_helpers = 1
      -- Don't run on :w; big queries would fire on every save. Use <leader>S.
      vim.g.db_ui_execute_on_save = 0
    end,
  },

  {
    "kristijanhusak/vim-dadbod-completion",
    dependencies = { "tpope/vim-dadbod" },
    ft = sql_ft,
  },

  -- Table/column/keyword completion in SQL buffers. per_filetype keeps the
  -- source out of non-SQL buffers; inherit_defaults keeps lsp/path/snippets/buffer.
  -- `jinja.sql` (dbt models, see dbt.lua) is listed explicitly in case blink
  -- matches the compound filetype as a whole.
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "kristijanhusak/vim-dadbod-completion" },
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" }
      opts.sources.per_filetype = opts.sources.per_filetype or {}
      for _, ft in ipairs(vim.list_extend({ "jinja.sql" }, sql_ft)) do
        opts.sources.per_filetype[ft] = { inherit_defaults = true, "dadbod" }
      end
    end,
  },

  -- Drawer on the right, results at the bottom, if edgy.nvim is ever enabled.
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        title = "Database",
        ft = "dbui",
        pinned = true,
        width = 0.3,
        open = function()
          vim.cmd("DBUI")
        end,
      })
      opts.bottom = opts.bottom or {}
      table.insert(opts.bottom, { title = "DB Query Result", ft = "dbout" })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "sql" })
    end,
  },
}
