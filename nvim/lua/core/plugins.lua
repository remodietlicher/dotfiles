local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
  use({ "wbthomason/packer.nvim" })
  use({ "nvim-tree/nvim-tree.lua" })
  use({ "Mofiqul/dracula.nvim" })
  use({ "EdenEast/nightfox.nvim" })
  use({ "morhetz/gruvbox" })
  use({ "rose-pine/neovim" })
  use({ "folke/tokyonight.nvim" })
  use({ "Mofiqul/vscode.nvim" })
  use({ "nvim-tree/nvim-web-devicons" })
  use({ "nvim-lualine/lualine.nvim" })
  use({ "nvim-treesitter/nvim-treesitter" })
  use({ "nvim-treesitter/nvim-treesitter-context" })
  use({ "bluz71/vim-nightfly-colors" })
  use({ "lewis6991/gitsigns.nvim" })
  use({
    "phaazon/hop.nvim",
    branch = "v2",
  })

  use({
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  })
  use({
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    requires = { { "nvim-lua/plenary.nvim" } },
  })
  use({
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "make",
  })
  use({ "folke/which-key.nvim" })
  use({ "tpope/vim-fugitive" })
  use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "onsails/lspkind-nvim" },
      { "hrsh7th/cmp-cmdline" },
      { "saadparwaiz1/cmp_luasnip" },
      { "L3MON4D3/LuaSnip" },
      { "rafamadriz/friendly-snippets" },
      { "rcarriga/cmp-dap" },
    },
  })
  use({ "preservim/nerdcommenter" })
  use({ "mfussenegger/nvim-dap" })
  use({ "mfussenegger/nvim-dap-python" })
  use({
    "mxsdev/nvim-dap-vscode-js",
    requires = {
      "microsoft/vscode-js-debug",
      opt = true,
      run = "npm install --legacy-peer-deps && npm run compile",
    },
  })
  use({ "rcarriga/nvim-dap-ui" })
  use({ "rmagatti/auto-session" })
  use({ "jose-elias-alvarez/null-ls.nvim" })
  use({ "kylechui/nvim-surround" })
  use({ "epwalsh/obsidian.nvim" })
  use({
    "akinsho/toggleterm.nvim",
    tag = "*",
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
