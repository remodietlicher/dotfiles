local dap = require("dap")

dap.adapters.python = {
  type = "executable",
  command = "/usr/bin/python3",
  args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = "launch",
    name = "Launch file",

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    program = "${file}", -- This configuration will launch the current file if used.
    pythonPath = function()
      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
        return cwd .. "/venv/bin/python"
      elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
        return cwd .. "/.venv/bin/python"
      else
        return "/usr/bin/python"
      end
    end,
  },
  {
    name = "Attach to 5678",
    type = "python",
    request = "attach",
    justMyCode = true,
    connect = {
      host = "localhost",
      port = 5678,
    },
    pythonPath = vim.fn.getcwd() .. "/.venv/bin/python",
  },
}

vim.keymap.set("n", "<leader>dc", dap.continue, {})
vim.keymap.set("n", "<leader>do", dap.step_over, {})
vim.keymap.set("n", "<leader>di", dap.step_into, {})
vim.keymap.set("n", "<leader>db", dap.step_out, {})
vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, {})
vim.keymap.set("n", "<leader>dr", dap.repl.open, {})
vim.keymap.set("n", "<leader>dl", dap.run_last, {})
