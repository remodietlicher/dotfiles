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
| `herdr/config.toml` | `~/.config/herdr/config.toml` | herdr (tmux alternative, mirrors `tmux.conf`) |
| `zsh/zshrc`      | *sourced* from `~/.zshrc` (see below) | zsh |

## zsh — sourced, not symlinked

`zsh/zshrc` is the one config here that is **not** symlinked into place. `~/.zshrc`
stays the machine's own file and pulls this one in with a single line at the end:

    [[ -f ~/code/dotfiles/zsh/zshrc ]] && source ~/code/dotfiles/zsh/zshrc

Two reasons not to symlink it. Installers (brew, rustup, uv, conda) append their
init lines to `~/.zshrc` — through a symlink those writes land in this repo, and
**this repo is public**, which is how a token eventually gets committed. And
`~/.zshrc` staying machine-owned means a second machine can differ without a
branch.

The split that follows from that:

- **`zsh/zshrc`** (here, committed) — portable settings: exports, aliases,
  widget config.
- **`~/.zshrc`** (machine, un-tracked) — whatever installers wrote, plus the one
  source line.
- **`~/.zshrc.local`** (machine, un-tracked) — secrets and per-host paths. It is
  sourced last, so it can override anything above; this is the private file the
  LiteLLM section below refers to for `LITELLM_BASE_URL` / `LITELLM_API_KEY`.

## The stack

Ghostty → tmux → Neovim. The tmux prefix is **Ctrl-Space** (`\x00`).

## Cmd-key shortcuts pattern

Inside a terminal, Ghostty can't tell the focused app is Neovim, and tmux/nvim
never see the Cmd modifier directly. The convention here is to make Ghostty
translate a Cmd-combo into a **raw byte sequence** via `keybind = cmd+X=text:...`.
Those bytes pass through tmux untouched (as long as they don't collide with the
`\x00` prefix) and Neovim reads them. Examples in `ghostty/config`:

- `cmd+left` / `cmd+right` → `\x0f` / `\x09` → nvim `<C-o>` / `<C-i>` (jumplist)
- `cmd+w` → `\x1b[119;9u` (kitty-protocol Super+w) → nvim decodes as `<D-w>` →
  `Snacks.bufdelete` (close buffer). nvim 0.11 decodes the raw CSI-u bytes with
  no protocol negotiation, so this works through tmux as plain pass-through.
- `cmd+h/l` and `cmd+j/k` → `\x1b[…;9u` → herdr `cmd+h/l` (previous/next tab)
  and `cmd+k/j` (previous/next space), bound in `herdr/config.toml`. herdr
  ignores a raw `\x00`-prefix sequence, so herdr bindings use CSI-u, not
  `text:\x00…`.

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
- zsh: `exec zsh` (re-runs `~/.zshrc`, which re-sources `zsh/zshrc`). Existing
  shells keep the old values until then.
