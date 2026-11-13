return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        -- <leader>n (notification history): <c-y> copies the message of the
        -- current notification -- or of all <Tab>-marked ones -- to the system
        -- clipboard, e.g. to paste an error into a chat or issue.
        notifications = {
          actions = {
            copy_msg = function(picker)
              local msgs = {}
              for _, item in ipairs(picker:selected({ fallback = true })) do
                local n = item.item
                msgs[#msgs + 1] = ("[%s] %s%s"):format(
                  n.level,
                  n.title and n.title ~= "" and (n.title .. ": ") or "",
                  n.msg
                )
              end
              if #msgs == 0 then
                return
              end
              vim.fn.setreg("+", table.concat(msgs, "\n\n"))
              Snacks.notify.info(("Copied %d notification(s)"):format(#msgs))
            end,
          },
          win = {
            input = { keys = { ["<c-y>"] = { "copy_msg", mode = { "i", "n" } } } },
            list = { keys = { ["<c-y>"] = "copy_msg" } },
          },
        },
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
