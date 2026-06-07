return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    explorer = { enabled = true },
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
    styles = {
      notification = {
        wo = { wrap = true },
      },
    },
  },
}
