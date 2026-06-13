-- Jump anywhere on screen with labelled motions.
-- Ships with LazyVim by default; this spec makes it explicit and adds a binding.
-- <leader>l starts a flash jump: type as many chars as you want, then hit a
-- label to jump there.
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "<leader>l",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
  },
}
