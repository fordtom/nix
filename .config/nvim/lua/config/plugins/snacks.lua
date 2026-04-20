return {
   "folke/snacks.nvim",
   dependencies = {
      "echasnovski/mini.icons",
      "nvim-tree/nvim-web-devicons"
   },
   priority = 1000,
   lazy = false,
   opts = {
      bigfile = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = {
         enabled = true,
         timeout = 3000,
      },
      picker = {
         enabled = true,
         files = {
            ignored = true,
            hidden = true,
            exclude = { ".cache", ".git", "*/Python/Lib", ".jj" },
         },
         git = {
            files = {
               submodules = true,
            },
         },
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
         notification = {
            wo = { wrap = true } -- Wrap notifications
         }
      }
   },
}
