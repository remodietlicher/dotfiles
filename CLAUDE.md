# dotfiles

Single source of truth for the local dev environment. The terminal, editor, and
multiplexer configs all live here and are **symlinked** into place, so edits in
this repo are live (after reloading the relevant app):

| Repo path        | Symlinked to                  | App     |
| ---------------- | ----------------------------- | ------- |
| `ghostty/`       | `~/.config/ghostty`           | Ghostty |
| `nvim/`          | `~/.config/nvim`              | Neovim (LazyVim) |
| `tmux/tmux.conf` | `~/.config/tmux/tmux.conf`    | tmux    |
| `ideavim/.ideavimrc` | `~/.ideavimrc`            | IdeaVim |

## The stack

Ghostty → tmux → Neovim. The tmux prefix is **Ctrl-Space** (`\x00`).

## Cmd-key shortcuts pattern

Inside a terminal, Ghostty can't tell the focused app is Neovim, and tmux/nvim
never see the Cmd modifier directly. The convention here is to make Ghostty
translate a Cmd-combo into a **raw byte sequence** via `keybind = cmd+X=text:...`.
Those bytes pass through tmux untouched (as long as they don't collide with the
`\x00` prefix) and Neovim reads them. Examples in `ghostty/config`:

- `cmd+left` / `cmd+right` → `\x0f` / `\x09` → nvim `<C-o>` / `<C-i>` (jumplist)
- `cmd+j` → `\x00z` → tmux pane zoom toggle
- `cmd+w` → `\x1b[119;9u` (kitty-protocol Super+w) → nvim decodes as `<D-w>` →
  `Snacks.bufdelete` (close buffer). nvim 0.11 decodes the raw CSI-u bytes with
  no protocol negotiation, so this works through tmux as plain pass-through.

When adding such a binding, wire all three layers: the `text:` mapping in
`ghostty/config`, pass-through awareness in `tmux/tmux.conf` if relevant, and the
`<D-…>`/control-key mapping in `nvim/lua/config/keymaps.lua`.

## Reloading after edits

- Ghostty: `Cmd+Shift+,` (reload config) or restart the app.
- tmux: `prefix + r` (sources `~/.config/tmux/tmux.conf`).
- Neovim: restart, or `:source` the changed file.
