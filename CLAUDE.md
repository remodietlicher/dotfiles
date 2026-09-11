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
| `opencode/opencode.json` | `~/.config/opencode/opencode.json` | opencode |

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

## opencode + the LiteLLM gateway

`opencode/opencode.json` is symlinked as a **single file**, not as a directory
like `ghostty/` and `nvim/` — opencode owns the rest of `~/.config/opencode`
(it writes `node_modules/`, `package.json`, and auth state there), so only the
config file belongs in git.

The `litellm` provider points at a remote LiteLLM gateway. **This repo is public**,
so neither the token nor the hostname is committed — both are read from the
environment via opencode's `{env:VAR}` substitution, and unset vars silently
become an empty string. Export them from a private, un-committed file:

    export LITELLM_BASE_URL="https://<gateway-host>/v1"   # note the /v1 suffix
    export LITELLM_API_KEY="sk-..."

LiteLLM only serves the model names its own `model_list` defines, and opencode
needs each one declared explicitly under `provider.litellm.models`. List what the
gateway offers with:

    curl -s "$LITELLM_BASE_URL/models" \
      -H "Authorization: Bearer $LITELLM_API_KEY" | jq -r '.data[].id'

then add them under `provider.litellm.models`. The top-level `"model"` key sets
the default (currently `litellm/qwen3.8-27b`); override per run with
`opencode --model <provider>/<id>`, or per session with `/models` in the TUI.

## Reloading after edits

- Ghostty: `Cmd+Shift+,` (reload config) or restart the app.
- tmux: `prefix + r` (sources `~/.config/tmux/tmux.conf`).
- Neovim: restart, or `:source` the changed file.
