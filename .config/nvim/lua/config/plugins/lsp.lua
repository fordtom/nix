return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    vim.lsp.config("pyright", {
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          },
        },
      },
      on_attach = function(client, _)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    })

    vim.lsp.config("clangd", {
      filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "cla" },
      cmd = { "clangd", "--log=verbose", "--background-index" },
      root_markers = { "compile_commands.json", ".git" },
    })

    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "pyright", "clangd", "zls" },
      automatic_enable = true,
    })
  end,
}
