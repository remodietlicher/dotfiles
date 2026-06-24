return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          -- Always show dotfiles and gitignored files in the tree.
          hidden = true,
          ignored = true,
          layout = {
            -- The explorer uses the "sidebar" preset; override only the
            -- position so the tree opens on the right instead of the left.
            layout = {
              position = "right",
            },
          },
          actions = {
            -- Mark two files with <Tab>, then press D to diff them in a new
            -- tab (mirrors the <leader>dc clipboard diff).
            diff_selected = function(picker)
              local sel = picker:selected({ fallback = false })
              if #sel ~= 2 then
                Snacks.notify.warn("Select exactly 2 files to diff (<Tab> to mark)")
                return
              end
              picker:close()
              vim.cmd("tabnew " .. vim.fn.fnameescape(sel[1].file))
              vim.cmd("diffthis")
              vim.cmd("vert diffsplit " .. vim.fn.fnameescape(sel[2].file))
            end,
          },
          win = {
            list = {
              keys = {
                ["D"] = "diff_selected",
              },
            },
          },
        },
      },
    },
  },
}
