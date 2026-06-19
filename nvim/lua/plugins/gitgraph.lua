return {
  {
    "isakbm/gitgraph.nvim",
    -- diffview powers the <CR> diff hooks below; it's declared standalone in
    -- diffview.lua, listed here too so gitgraph is self-contained if loaded first.
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
    config = function(_, opts)
      require("gitgraph").setup(opts)

      -- `co` in the graph: check out the commit under the cursor.
      --
      -- gitgraph exposes no commit-under-cursor API (the row->commit lookup needs
      -- the plugin's internal `graph` local, reachable only from its own <CR>
      -- maps), so we parse the short hash straight off the buffer line. Commits
      -- render on odd rows (utils.lua get_commit_from_row); even rows are the
      -- message/connector rows, so map the cursor down to its commit row first.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "gitgraph",
        callback = function(ev)
          vim.keymap.set("n", "co", function()
            local r = vim.api.nvim_win_get_cursor(0)[1]
            local commit_row = 2 * math.floor((r - 1) / 2) + 1
            local line = vim.api.nvim_buf_get_lines(0, commit_row - 1, commit_row, false)[1] or ""
            -- First isolated 7-hex run on the row is the short hash (rendered
            -- first, always exactly 7 chars). Frontier both sides so a longer
            -- hex-ish token later on the line (branch/tag/author) can't match.
            local hash = line:match("%f[%x](%x%x%x%x%x%x%x)%f[%X]")
            if not hash then
              vim.notify("gitgraph: no commit on this line", vim.log.levels.WARN)
              return
            end
            local out = vim.fn.system({ "git", "checkout", hash })
            if vim.v.shell_error ~= 0 then
              vim.notify("git checkout " .. hash .. " failed:\n" .. out, vim.log.levels.ERROR)
              return
            end
            vim.notify("Checked out " .. hash)
            -- Redraw so HEAD/branch markers reflect the new checkout.
            require("gitgraph").draw({}, { all = true, max_count = 5000 })
          end, { buffer = ev.buf, desc = "Gitgraph: checkout commit under cursor" })
        end,
      })
    end,
  },
}
