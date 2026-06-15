return {
  {
    "sindrets/diffview.nvim",
    -- Lazy-load on its commands and on the <leader>gv review keymaps
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewFileHistory",
    },
    keys = {
      -- Your own uncommitted changes (working tree vs index/HEAD)
      { "<leader>gvd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: working tree" },
      -- PR-style review: diff any branch/ref. Default is the merge-base diff of
      -- your branch vs origin/main (the `...` GitHub-style view). Edit the ref
      -- or the default below if your base branch isn't origin/main.
      {
        "<leader>gvb",
        function()
          vim.ui.input({ prompt = "Diffview ref: ", default = "origin/main...HEAD" }, function(ref)
            if ref and ref ~= "" then
              vim.cmd("DiffviewOpen " .. ref)
            end
          end)
        end,
        desc = "Diffview: vs ref (prompt)",
      },
      -- History of the current file
      { "<leader>gvf", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: file history" },
      -- History of the whole repo
      { "<leader>gvr", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: repo history" },
      -- Close from anywhere
      { "<leader>gvq", "<cmd>DiffviewClose<cr>", desc = "Diffview: close" },
    },
    opts = {
      enhanced_diff_hl = true, -- richer diff highlighting
    },
  },
}
