return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          layout = {
            -- The explorer uses the "sidebar" preset; override only the
            -- position so the tree opens on the right instead of the left.
            layout = {
              position = "right",
            },
          },
        },
      },
    },
  },
}
