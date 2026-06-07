local function enable_if_executable(server, executable)
  if vim.fn.executable(executable) == 1 then
    vim.lsp.enable(server)
  end
end

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

enable_if_executable("clangd", "clangd")
enable_if_executable("gopls", "gopls")
enable_if_executable("rust_analyzer", "rust-analyzer")
enable_if_executable("zls", "zls")
enable_if_executable("ty", "ty")
