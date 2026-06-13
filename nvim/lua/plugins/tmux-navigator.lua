-- Seamless navigation between nvim splits and tmux panes with Ctrl-h/j/k/l.
-- Pairs with the matching plugin + bindings in tmux/tmux.conf.
return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Go to left window/pane" },
    { "<c-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Go to lower window/pane" },
    { "<c-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Go to upper window/pane" },
    { "<c-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to right window/pane" },
  },
}
