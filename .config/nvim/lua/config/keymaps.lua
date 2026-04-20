local Snacks = require("snacks")

vim.keymap.set("n", "<leader><space>", function() Snacks.picker.pickers() end, { desc = "Meta picker" })

-- UI toggles
vim.keymap.set("n", "<C-e>", function() Snacks.picker.explorer()           end, { desc = "Explore files" })

-- Files
vim.keymap.set("n", "<leader>sf", function() Snacks.picker.files()           end, { desc = "Files" })
vim.keymap.set("n", "<leader>sg", function() Snacks.picker.git_files() end, { desc = "Tracked" })

-- Grep
vim.keymap.set("n", "<leader>if", function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set("n", "<leader>ig", function() Snacks.picker.git_grep() end, { desc = "Grep" })

-- LSP functionality
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions()      end, { desc = "Goto Definition" })
vim.keymap.set("n", "gD", function() Snacks.picker.lsp_declarations()     end, { desc = "Goto Declaration" })
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references()       end, { nowait = true }, { desc = "References" })
vim.keymap.set("n", "gi", function() Snacks.picker.lsp_implementations()  end, { desc = "Goto Implementation" })
vim.keymap.set("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })

-- Better text movement
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")

-- Centering on teleports
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "gb", "<C-o>zz", { noremap = true, silent = true })
vim.keymap.set("n", "gf", "<C-i>zz", { noremap = true, silent = true })

-- Other
vim.keymap.set("x", "<leader>p", "\"_dP")
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "Q", "<nop>")

-- Window and tab management
vim.keymap.set('n', '<A-h>', "<C-w>h", { noremap = true, silent = true })
vim.keymap.set('n', '<A-j>', "<C-w>j", { noremap = true, silent = true })
vim.keymap.set('n', '<A-k>', "<C-w>k", { noremap = true, silent = true })
vim.keymap.set('n', '<A-l>', "<C-w>l", { noremap = true, silent = true })
vim.keymap.set('n', '<A-w>', ":close<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<A-s>', ":vsplit<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-d>", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
for i = 1, 9 do
   vim.keymap.set('n', '<A-'..i..'>', '<cmd>LualineBuffersJump! ' .. i .. '<CR>', { noremap = true, silent = true })
end

vim.keymap.set('n', '<leader>r', ":%s/\\<<C-r><C-w>\\>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>R', ":bufdo %s/\\<<C-r><C-w>\\>", { noremap = true, silent = true })
