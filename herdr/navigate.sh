#!/bin/sh
# Ctrl-h/j/k/l in herdr, like vim-tmux-navigator in tmux. Bound in
# herdr/config.toml. If the focused pane runs (n)vim, the key goes on to nvim,
# which moves between its own splits and calls back into herdr at their edge
# (nvim/lua/plugins/tmux-navigator.lua). Any other pane moves herdr's focus.
#
# Usage: navigate.sh left|down|up|right h|j|k|l
info=$(herdr pane process-info) || exit
# argv0 too: name is what the process calls itself (claude shows its version).
if printf '%s' "$info" | jq -e '[.. | .foreground_processes? // empty | .[] | .name, .argv0 | strings] | any(test("^n?vim$"))' >/dev/null; then
  herdr pane send-keys "$(printf '%s' "$info" | jq -r '[.. | .pane_id? // empty][0]')" "ctrl+$2"
else
  herdr pane focus --direction "$1"
fi
