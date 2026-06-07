local function set_transparent_bars()
  for _, group in ipairs({
    "StatusLine",
    "StatusLineNC",
    "TabLine",
    "TabLineFill",
    "TabLineSel",
    "WinBar",
    "WinBarNC",
  }) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
  end
end

require("lualine").setup({
  options = {
    component_separators = "",
    section_separators = "",
    globalstatus = true,
    disabled_filetypes = {
      statusline = { "snacks_dashboard" },
    },
    theme = {
      normal = {
        a = { fg = "black", bg = "magenta" },
        b = { fg = "white", bg = "darkgray" },
        c = { fg = "white", bg = "None" },
      },
      insert = {
        a = { fg = "black", bg = "blue" },
        c = { fg = "white", bg = "None" },
      },
      visual = {
        a = { fg = "black", bg = "cyan" },
        c = { fg = "white", bg = "None" },
      },
      replace = {
        a = { fg = "black", bg = "red" },
        c = { fg = "white", bg = "None" },
      },
      command = {
        a = { fg = "black", bg = "magenta" },
        c = { fg = "white", bg = "None" },
      },
      terminal = {
        a = { fg = "black", bg = "blue" },
        c = { fg = "white", bg = "None" },
      },
      inactive = {
        a = { fg = "white", bg = "None" },
        b = { fg = "white", bg = "None" },
        c = { fg = "darkgray", bg = "None" },
      },
    },
  },
  sections = {
    lualine_a = {
      {
        function()
          return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        end,
        padding = { left = 1, right = 0 },
        separator = { left = "" },
      },
      {
        "branch",
        fmt = function(branch)
          if branch == "" then
            return ""
          end

          return "on  " .. branch
        end,
        icon = "",
        padding = { left = 0, right = 1 },
        separator = { right = "" },
      },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { { "mode", separator = { left = "", right = "" } } },
  },
  tabline = {
    lualine_c = {
      {
        "buffers",
        mode = 2,
        icons_enabled = false,
        symbols = {
          alternate_file = "",
        },
      },
    },
  },
  winbar = {
    lualine_a = {
      {
        "filename",
        path = 1,
        separator = { left = "", right = "" },
      },
    },
    lualine_c = { "diff" },
  },
  inactive_winbar = {
    lualine_a = {
      {
        "filename",
        path = 1,
        separator = { left = "", right = "" },
      },
    },
  },
})

set_transparent_bars()
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_transparent_bars,
})
