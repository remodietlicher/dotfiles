-- GDScript in Neovim, backed by the Godot editor itself.
--
-- Godot doesn't ship a standalone language server: the *running Godot editor*
-- hosts the LSP over TCP (port 6005, the Godot 4 default). So the workflow is:
-- keep the Godot editor open on the project, and nvim connects to it for
-- completion / diagnostics / goto-definition. With no editor running you still
-- get plain editing + treesitter highlighting, just no LSP.
--
-- To make Godot's "open script" click land in this nvim instead of Godot's
-- built-in editor, nvim listens on a pipe (started below when inside a Godot
-- project) and Godot is configured once via Editor Settings > Text Editor >
-- External:
--
--   Use External Editor: on
--   Exec Path:  full path to nvim (`which nvim`)
--   Exec Flags: --server /tmp/godot.pipe --remote-send "<C-\><C-N>:e {file}<CR>:call cursor({line},{col})<CR>"

-- Listen for Godot's external-editor calls, but only when this nvim was
-- started inside a Godot project. pcall: a second nvim in the same project
-- must not error out because the pipe is already taken by the first.
local is_godot_project = #vim.fs.find("project.godot", { upward = true, path = vim.fn.getcwd() }) > 0
if is_godot_project then
  pcall(vim.fn.serverstart, "/tmp/godot.pipe")
end

return {
  -- 1. LSP: connect to the Godot editor's built-in language server over TCP.
  --    nvim-lspconfig ships a `gdscript` preset; the explicit fields below
  --    mirror it so this works even if the pinned lspconfig predates changes.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gdscript = {
          cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),
          filetypes = { "gd", "gdscript", "gdscript3" },
          root_markers = { "project.godot", ".git" },
        },
      },
    },
  },

  -- 2. Highlighting: GDScript plus Godot's scene/resource and shader formats.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "gdscript", "godot_resource", "gdshader" })
    end,
  },

  -- 3. Formatting: gdformat (gdtoolkit) via conform; Godot's LSP exposes no
  --    formatter. Installed through Mason.
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { gdscript = { "gdformat" } },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "gdtoolkit" } },
  },
}
