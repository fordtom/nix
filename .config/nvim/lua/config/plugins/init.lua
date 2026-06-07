vim.pack.add({
  { src = "https://github.com/echasnovski/mini.icons" },
  { src = "https://github.com/folke/snacks.nvim" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
  { src = "https://github.com/tpope/vim-sleuth" },
})

require("config.plugins.icons")
require("config.plugins.snacks")
require("config.plugins.lualine")
require("config.plugins.lsp")
require("config.plugins.blink")
