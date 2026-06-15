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
        -- <CR> on a commit: compare it to the checked-out HEAD via the merge-base
        -- (the `...` GitHub-style PR diff). Flow: check out the PR branch, find
        -- the target branch's commit in the graph, <CR> -> see exactly what the
        -- PR changes relative to that target. (Swap "..." for ".." if you ever
        -- want a literal two-tree diff instead of the merge-base one.)
        on_select_commit = function(commit)
          vim.cmd("DiffviewOpen " .. commit.hash .. "...HEAD")
        end,
        -- Visual-select commits then <CR>: diff across the selection. Select a
        -- single commit this way to inspect just that commit's own changes.
        on_select_range_commit = function(from, to)
          vim.cmd("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
        end,
      },
    },
  },
}
