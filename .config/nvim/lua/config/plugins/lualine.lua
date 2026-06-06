return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      component_separators = "",
      section_separators = "",
      globalstatus = true,
      theme = function()
        local function hl(group, key, fallback)
          local value = vim.api.nvim_get_hl(0, { name = group, link = false })[key]
          return value and string.format("#%06x", value) or fallback
        end

        local colors = {
          black = hl("PmenuSel", "fg", "#2A2A2A"),
          blue = hl("PmenuSel", "bg", "#85C1FC"),
          cyan = hl("MoreMsg", "fg", "#88C0D0"),
          greybg = hl("Comment", "fg", "#505050"),
          inactive = hl("Comment", "fg", "#505050"),
          red = hl("DiagnosticError", "fg", "#BF616A"),
          violet = hl("Type", "fg", "#AA9BF5"),
          white = hl("Normal", "fg", "#D8DEE9"),
        }

        return {
          normal = {
            a = { fg = colors.black, bg = colors.violet },
            b = { fg = colors.white, bg = colors.greybg },
            c = { fg = colors.white, bg = "None" },
          },
          insert = {
            a = { fg = colors.black, bg = colors.blue },
            c = { fg = colors.white, bg = "None" },
          },
          visual = {
            a = { fg = colors.black, bg = colors.cyan },
            c = { fg = colors.white, bg = "None" },
          },
          replace = {
            a = { fg = colors.black, bg = colors.red },
            c = { fg = colors.white, bg = "None" },
          },
          command = {
            a = { fg = colors.black, bg = colors.violet },
            c = { fg = colors.white, bg = "None" },
          },
          terminal = {
            a = { fg = colors.black, bg = colors.blue },
            c = { fg = colors.white, bg = "None" },
          },
          inactive = {
            a = { fg = colors.white, bg = "None" },
            b = { fg = colors.white, bg = "None" },
            c = { fg = colors.inactive, bg = "None" },
          },
        }
      end,
    },
    sections = {
      lualine_a = {
        {
          function()
            local root = vim.fn.getcwd()
            return vim.fn.fnamemodify(root, ":t")
          end,
          separator = { left = "" },
        },
      },
      lualine_b = { { "branch", separator = { right = "" } } },
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
  },
  config = function(_, opts)
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

    require("lualine").setup(
      vim.tbl_deep_extend("force", opts, {
        options = {
          disabled_filetypes = {
            statusline = { "snacks_dashboard" },
          },
        },
      })
    )

    set_transparent_bars()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = set_transparent_bars,
    })
  end,
}
