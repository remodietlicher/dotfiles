-- HTTP client for .http / .rest files (kulala.nvim).
--
-- Runs IntelliJ / VS Code REST-client style request files directly from the
-- buffer. It understands the `{{var}}` template syntax used in our repos,
-- the built-in `{{$timestamp}}` dynamic variable, and resolves named vars
-- (baseurl, tokens, ...) from a sibling `http-client.env.json` (IntelliJ
-- format). Put secrets in `http-client.private.env.json` (git-ignored) — it
-- overrides the public env file.
--
-- Needs `curl` (required) and `jq` (response formatting); both already present.
return {
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    opts = {
      -- which env block in http-client.env.json to use by default.
      -- This repo's env file names the localhost block "local"; switch at
      -- runtime with <leader>Re (set_selected_env) to hit dev/prod/etc.
      default_env = "local",
    },
    keys = {
      { "<leader>R", "", desc = "+rest", ft = { "http", "rest" } },
      { "<leader>Rs", function() require("kulala").run() end, ft = { "http", "rest" }, desc = "Send request under cursor" },
      { "<leader>Ra", function() require("kulala").run_all() end, ft = { "http", "rest" }, desc = "Send all requests" },
      { "<leader>Rr", function() require("kulala").replay() end, ft = { "http", "rest" }, desc = "Replay last request" },
      { "<leader>Re", function() require("kulala").set_selected_env() end, ft = { "http", "rest" }, desc = "Select target environment" },
      { "<leader>Rc", function() require("kulala").copy() end, ft = { "http", "rest" }, desc = "Copy as curl" },
      { "<leader>Rq", function() require("kulala").close() end, ft = { "http", "rest" }, desc = "Close response window" },
    },
  },
  -- Ensure the treesitter grammar kulala parses requests with is installed.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "http" })
    end,
  },
}
