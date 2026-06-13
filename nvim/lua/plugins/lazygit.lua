-- Make lazygit (opened via <leader>gg / Snacks.lazygit) open files in THIS
-- neovim as a buffer in the current window — not a new nvim instance, and not a
-- new tab (which the built-in `nvim-remote` editPreset does).
--
-- snacks launches lazygit in a terminal where $NVIM points at this instance's
-- RPC server, and merges this `config` into the lazygit config it writes. An
-- explicit os.edit overrides the editPreset. We close the lazygit float
-- (--remote-send "q") then open the file with --remote-silent, which edits it in
-- the current window of the parent nvim (a plain buffer). The `[ -z "$NVIM" ]`
-- guard keeps it working if lazygit is ever launched outside nvim.
return {
  "folke/snacks.nvim",
  opts = {
    lazygit = {
      config = {
        os = {
          edit = '[ -z "$NVIM" ] && (nvim -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote-silent {{filename}})',
          editAtLine = '[ -z "$NVIM" ] && (nvim +{{line}} -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote-silent {{filename}} && nvim --server "$NVIM" --remote-send ":{{line}}<CR>")',
          editAtLineAndWait = 'nvim +{{line}} {{filename}}',
        },
      },
    },
  },
}
