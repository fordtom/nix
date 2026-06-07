-- Set leader before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Install and configure plugins
require("config.plugins")

-- Load options and keymaps
require("config.options")
require("config.treesitter")
require("config.terminal_colors")
require("config.keymaps")
