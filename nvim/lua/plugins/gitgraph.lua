return {
  {
    "isakbm/gitgraph.nvim",
    -- diffview is already pulled in by neogit; selecting a commit opens it there
    dependencies = { "sindrets/diffview.nvim" },
    keys = {
      {
        "<leader>gG",
        function()
          require("gitgraph").draw({}, { all = true, max_count = 5000 })
        end,
        desc = "Git graph",
      },
    },
    opts = {
      format = {
        timestamp = "%Y-%m-%d %H:%M",
        fields = { "hash", "timestamp", "author", "branch_name", "tag" },
      },
      hooks = {
        -- <enter> on a commit -> open that commit's diff in diffview
        on_select_commit = function(commit)
          vim.cmd(":DiffviewOpen " .. commit.hash .. "^!")
        end,
        -- visual-select a range of commits -> diff the whole range
        on_select_range_commit = function(from, to)
          vim.cmd(":DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
        end,
      },
    },
  },
}
