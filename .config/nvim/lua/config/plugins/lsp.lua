vim.lsp.config("ty", {
  settings = {
    ty = {
      diagnosticMode = "workspace",
    },
  },
})

vim.lsp.config("clangd", {
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "cla" },
  cmd = { "clangd", "--log=verbose", "--background-index" },
  root_markers = { "compile_commands.json", ".git" },
})

vim.lsp.enable("clangd")
vim.lsp.enable("gopls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("zls")
vim.lsp.enable("ty")
vim.lsp.enable("ts_ls")
