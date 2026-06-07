local Snacks = require("snacks")

vim.keymap.set("n", "<leader><space>", function() Snacks.picker.pickers() end, { desc = "Meta picker" })

vim.keymap.set("n", "<C-e>", function() Snacks.picker.explorer() end, { desc = "Explore files" })

vim.keymap.set("n", "<leader>sf", function() Snacks.picker.files() end, { desc = "Files" })
vim.keymap.set("n", "<leader>sg", function() Snacks.picker.git_files() end, { desc = "Tracked" })

vim.keymap.set("n", "<leader>if", function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set("n", "<leader>ig", function() Snacks.picker.git_grep() end, { desc = "Git grep" })

vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto definition" })
vim.keymap.set("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto declaration" })
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "References", nowait = true })
vim.keymap.set("n", "gi", function() Snacks.picker.lsp_implementations() end, { desc = "Goto implementation" })
vim.keymap.set("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto type definition" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "gb", "<C-o>zz", { silent = true })
vim.keymap.set("n", "gf", "<C-i>zz", { silent = true })

vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<A-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<A-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<A-k>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<A-l>", "<C-w>l", { silent = true })
vim.keymap.set("n", "<A-w>", ":close<CR>", { silent = true })
vim.keymap.set("n", "<A-s>", ":vsplit<CR>", { silent = true })
vim.keymap.set("n", "<A-d>", function()
  Snacks.bufdelete()
end, { desc = "Delete buffer" })

for i = 1, 9 do
  vim.keymap.set("n", "<A-" .. i .. ">", "<cmd>LualineBuffersJump! " .. i .. "<CR>", { silent = true })
end

vim.keymap.set("n", "<leader>r", ":%s/\\<<C-r><C-w>\\>", { silent = true })
vim.keymap.set("n", "<leader>R", ":bufdo %s/\\<<C-r><C-w>\\>", { silent = true })
