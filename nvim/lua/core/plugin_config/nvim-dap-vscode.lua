local dapVS = require("dap.ext.vscode")

dapVS.load_launchjs(nil, { cppdbg = { "cpp", "cc", "c" } })
