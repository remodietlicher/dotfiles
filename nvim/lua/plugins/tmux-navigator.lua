-- Seamless navigation between nvim splits and tmux/herdr panes with Ctrl-h/j/k/l.
-- tmux: vim-tmux-navigator, paired with the matching plugin in tmux/tmux.conf.
-- herdr: herdr/navigate.sh passes Ctrl-h/j/k/l on to nvim; at the edge of
-- nvim's splits, this hands focus back to herdr's neighboring pane.
local dirs = {
  h = { "Left", "left" },
  j = { "Down", "down" },
  k = { "Up", "up" },
  l = { "Right", "right" },
}

local function navigate(key)
  local tmux, herdr = unpack(dirs[key])
  if vim.env.TMUX then
    return vim.cmd("TmuxNavigate" .. tmux)
  end
  local win = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. key)
  if vim.env.HERDR_PANE_ID and vim.api.nvim_get_current_win() == win then
    vim.system({ "herdr", "pane", "focus", "--pane", vim.env.HERDR_PANE_ID, "--direction", herdr })
  end
end

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
    { "<c-h>", function() navigate("h") end, desc = "Go to left window/pane" },
    { "<c-j>", function() navigate("j") end, desc = "Go to lower window/pane" },
    { "<c-k>", function() navigate("k") end, desc = "Go to upper window/pane" },
    { "<c-l>", function() navigate("l") end, desc = "Go to right window/pane" },
  },
}
