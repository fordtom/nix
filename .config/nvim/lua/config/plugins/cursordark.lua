return {
  "ydkulks/cursor-dark.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("cursor-dark-midnight")
    require("cursor-dark").setup({
      style = "dark",
      transparent = true,
    })
  end
}
