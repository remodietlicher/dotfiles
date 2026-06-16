-- Bash/sh: format with shfmt via conform (LazyVim's formatter manager).
-- shfmt is Mason-installed (ensure_installed below); conform finds it via Mason's
-- bin on PATH. Note: bash scripts usually get filetype `sh` in nvim (with
-- b:is_bash set), so the `sh` key is the one that fires most of the time; `bash`
-- is keyed too for the rare explicit case.
--
-- shfmt defaults to tab indentation and honors a project `.editorconfig` if
-- present. To force a style regardless, uncomment the `formatters` block below:
--   -i 2  -> 2-space indent      -ci -> indent switch cases
--   -bn   -> binary ops at line start    -sr -> space after redirects
return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
        bash = { "shfmt" },
      },
      -- formatters = {
      --   shfmt = { prepend_args = { "-i", "2", "-ci" } },
      -- },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "shfmt" } },
  },
}
