local colors = {
  blue   = '#7DAEA3',
  cyan   = '#89B482',
  black  = '#080808',
  white  = '#D0D0D0',
  red    = '#EA6962',
  violet = '#D3869B',
  greybg   = '#505050',
  inactive = '#808080',
}

local transparent = 'none'

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.violet },
    b = { fg = colors.white, bg = colors.greybg },
    c = { fg = colors.white, bg = transparent },
  },

  insert = {
    a = { fg = colors.black, bg = colors.blue },
    c = { fg = colors.white, bg = transparent },
  },
  visual = {
    a = { fg = colors.black, bg = colors.cyan },
    c = { fg = colors.white, bg = transparent },
  },
  replace = {
    a = { fg = colors.black, bg = colors.red },
    c = { fg = colors.white, bg = transparent },
  },
  command = {
    a = { fg = colors.black, bg = colors.violet },
    c = { fg = colors.white, bg = transparent },
  },
  terminal = {
    a = { fg = colors.black, bg = colors.blue },
    c = { fg = colors.white, bg = transparent },
  },

  inactive = {
    a = { fg = colors.white, bg = transparent },
    b = { fg = colors.white, bg = transparent },
    c = { fg = colors.inactive, bg = transparent },
  },
}

return {
   "nvim-lualine/lualine.nvim",
   dependencies = { "nvim-tree/nvim-web-devicons" },
   config = function()
      local function set_transparent_bars()
         for _, group in ipairs({ "StatusLine", "StatusLineNC", "TabLineFill", "WinBar", "WinBarNC" }) do
            vim.api.nvim_set_hl(0, group, { bg = "none" })
         end
      end

      require("lualine").setup({
         options = {
            theme = bubbles_theme,
            component_separators = '',
            section_separators = '',
            globalstatus = true,
         },
         sections = {
            lualine_a = { { 'mode', separator = { left = '' } } },
            lualine_b = { { 'location', separator = { right = '' } } },
            lualine_c = {},
            lualine_x = {
               'branch',
            },
            lualine_y = {},
            lualine_z = { {
               function()
                  local root = vim.fn.getcwd()
                  return vim.fn.fnamemodify(root, ":t")
               end,
               separator = { left = '', right = '' },
            } },
         },
         tabline = {
            lualine_c = { {
               'buffers',
               mode = 2,
               icons_enabled = false,
               symbols = {
                  alternate_file = '',
               },
            } },
         },
         winbar = {
            lualine_a = { {
               'filename',
               path = 1,
               separator = { left = '', right = '' },
            } },
            lualine_c = {
               'diff',
            },
         },
         inactive_winbar = {
            lualine_a = { {
               'filename',
               path = 1,
               separator = { left = '', right = '' },
            } },
         },
      })

      set_transparent_bars()
      vim.api.nvim_create_autocmd("ColorScheme", {
         callback = set_transparent_bars,
      })
   end,
} 
