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
    keys = {
      -- Take over the main git key from lazygit. Lazygit stays on <leader>gl below.
      { "<leader>gg", function() require("neogit").open() end, desc = "Neogit" },
      { "<leader>gc", function() require("neogit").open({ "commit" }) end, desc = "Neogit commit" },
    },
    opts = {
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
