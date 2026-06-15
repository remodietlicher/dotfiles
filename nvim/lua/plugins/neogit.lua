return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim", -- enables `d` to open rich diffs from the status buffer
      "ibhagwan/fzf-lua", -- you already use this; neogit reuses it for pickers
    },
    -- Loaded on demand via the keymaps + :Neogit command
    cmd = "Neogit",
    -- Inside the Neogit status buffer, `gG` opens gitgraph — press it where you
    -- would otherwise reach for `L`. Change the key if it clashes with a neogit
    -- default (`?` in the status buffer lists the live mappings).
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "NeogitStatus",
        callback = function(ev)
          vim.keymap.set("n", "gG", function()
            require("gitgraph").draw({}, { all = true, max_count = 5000 })
          end, { buffer = ev.buf, desc = "Git graph (gitgraph.nvim)" })
        end,
      })
    end,
    keys = {
      -- Take over the main git key from lazygit. Lazygit stays on <leader>gl below.
      { "<leader>gg", function() require("neogit").open() end, desc = "Neogit" },
      { "<leader>gc", function() require("neogit").open({ "commit" }) end, desc = "Neogit commit" },
    },
    opts = {
      -- Commit graph in the `L` log view: "ascii" (default), "unicode", or
      -- "kitty". Ghostty speaks the kitty graphics protocol, so try "kitty"
      -- for a pixel-perfect graph; fall back to "unicode" if it doesn't draw.
      graph_style = "unicode",
      integrations = {
        fzf_lua = true,
        diffview = true,
      },
      -- Keep neogit's own buffers out of your way when closed
      kind = "tab", -- open the status buffer in a new tab (use "split"/"floating" if you prefer)
    },
  },
  -- Keep lazygit reachable during the transition (Snacks provides it).
  -- Remove this block once you've fully switched.
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>gl", function() require("snacks").lazygit() end, desc = "Lazygit" },
    },
  },
}
