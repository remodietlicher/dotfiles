return {
  {
    -- Make <leader>ghd a toggle: open the gitsigns diff, or close it if already open.
    -- Closing works by finding the gitsigns:// scratch window and dismissing it,
    -- which automatically takes the remaining window out of diff mode.
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      local orig = opts.on_attach
      opts.on_attach = function(bufnr)
        if orig then orig(bufnr) end
        vim.keymap.set("n", "<leader>ghd", function()
          if vim.wo.diff then
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
              local name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
              if name:match("^gitsigns://") then
                vim.api.nvim_win_close(win, false)
                return
              end
            end
            vim.cmd("diffoff!")
          else
            require("gitsigns").diffthis()
          end
        end, { buffer = bufnr, desc = "Diff This (toggle)" })
      end
    end,
  },
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
