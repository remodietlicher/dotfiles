local cmp = require('cmp')
local select_opts = {behavior = cmp.SelectBehavior.Select}

-- utility functions for keymaps
local tab_fun = function(fallback)
  local col = vim.fn.col('.') - 1

  if cmp.visible() then
    cmp.select_next_item(select_opts)
  elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
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

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>'] = cmp.mapping(tab_fun, {'i', 's'}),
    ['<S-Tab>'] = cmp.mapping(s_tab_fun, {'i', 's'}),
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
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
        cmdline_history = "[CmdLineHistory]",
      },
    }),
  },
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'cmdline' },
    { name = 'cmdline_history' },
  })
})
