-- DAP: make VSCode-style `.vscode/launch.json` debug configs work in nvim.
--
-- LazyVim's `dap.core` + `lang.python` extras provide the whole stack (nvim-dap,
-- nvim-dap-ui, nvim-dap-python/debugpy). Recent nvim-dap reads a repo's
-- `.vscode/launch.json` AUTOMATICALLY at the start of every debug session via
-- its built-in config provider (:help dap-launch.json) — so the old explicit
-- `load_launchjs()` call is no longer needed (and is now deprecated), and
-- neither is a manual reload keymap (each session re-reads the file).
--
-- The one thing still worth configuring: map the `debugpy` adapter `type` to the
-- `python` filetype, so a launch.json entry with `"type": "debugpy"` is offered
-- in python buffers. (`"type": "python"` already maps to `python` by default, so
-- only `debugpy` needs spelling out — included `python` too for clarity.)
--
-- `optional = true` => only extend the nvim-dap spec the dap extra already adds.
-- We set the mapping lazily (on dap load) to avoid force-loading dap at startup;
-- it just needs to exist before the first debug session reads launch.json.
return {
  "mfussenegger/nvim-dap",
  optional = true,
  init = function()
    local function set_type_map()
      local vscode = require("dap.ext.vscode")
      vscode.type_to_filetypes.python = { "python" }
      vscode.type_to_filetypes.debugpy = { "python" }
    end
    if package.loaded["dap"] then
      set_type_map()
      return
    end
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(ev)
        if ev.data == "nvim-dap" then
          set_type_map()
          return true -- one-shot: delete this autocmd
        end
      end,
    })
  end,
}
