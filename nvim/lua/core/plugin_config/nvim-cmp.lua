local cmp = require("cmp")

-- utility functions for keymaps
local select_opts = { behavior = cmp.SelectBehavior.Select }

local tab_fun = function(fallback)
  local col = vim.fn.col(".") - 1

  if cmp.visible() then
    cmp.select_next_item(select_opts)
  elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    fallback()
  else
    cmp.complete()
  end
end

local s_tab_fun = function(fallback)
  if cmp.visible() then
    cmp.select_prev_item(select_opts)
  else
    fallback()
  end
end

require("luasnip.loaders.from_vscode").lazy_load()

-- general completion setup
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<Tab>"] = cmp.mapping(tab_fun, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(s_tab_fun, { "i", "s" }),
  }),
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
  }),
  formatting = {
    format = require("lspkind").cmp_format({
      maxwidth = 50,
      preset = "default",
      menu = {
        nvim_lsp = "[LSP]",
        buffer = "[Buffer]",
        path = "[path]",
        nvim_lua = "[Lua]",
        luasnip = "[LuaSnip]",
        cmdline = "[CmdLine]",
      },
    }),
  },
  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
  end,
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "buffer" },
  }),
})

-- Turn on special vim completion for lua
cmp.setup.filetype("lua", {
  sources = cmp.config.sources({
    { name = "nvim_lua" },
  }),
})

-- turn on completion for dap
cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
  sources = {
    { name = "dap" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "cmdline" },
  }),
})
