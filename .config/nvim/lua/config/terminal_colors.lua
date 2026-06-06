local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

local function link(group, target)
  hl(group, { link = target })
end

local function apply()
  for _, group in ipairs({
    "Normal",
    "NormalNC",
    "NormalFloat",
    "SignColumn",
    "EndOfBuffer",
    "StatusLine",
    "StatusLineNC",
    "TabLine",
    "TabLineFill",
    "TabLineSel",
    "WinBar",
    "WinBarNC",
  }) do
    hl(group, { bg = "none" })
  end

  hl("Comment", { ctermfg = 8, italic = true })
  hl("String", { ctermfg = 10 })
  hl("Character", { ctermfg = 10 })
  hl("Number", { ctermfg = 11 })
  hl("Boolean", { ctermfg = 11 })
  hl("Float", { ctermfg = 11 })
  hl("Identifier", { ctermfg = 9 })
  hl("Function", { ctermfg = 14, bold = true })
  hl("Statement", { ctermfg = 13 })
  hl("Keyword", { ctermfg = 13 })
  hl("Operator", { ctermfg = 14 })
  hl("PreProc", { ctermfg = 13 })
  hl("Type", { ctermfg = 13 })
  hl("Special", { ctermfg = 14 })
  hl("Constant", { ctermfg = 13 })

  hl("DiagnosticError", { ctermfg = 9 })
  hl("DiagnosticWarn", { ctermfg = 11 })
  hl("DiagnosticInfo", { ctermfg = 12 })
  hl("DiagnosticHint", { ctermfg = 14 })
  hl("DiagnosticOk", { ctermfg = 10 })

  link("@comment", "Comment")
  link("@string", "String")
  link("@string.special", "Special")
  link("@character", "Character")
  link("@boolean", "Boolean")
  link("@number", "Number")
  link("@number.float", "Float")
  link("@constant", "Constant")
  link("@constant.builtin", "Constant")
  link("@variable", "Identifier")
  link("@variable.builtin", "Special")
  link("@variable.parameter", "Identifier")
  link("@property", "Identifier")
  link("@field", "Identifier")
  link("@function", "Function")
  link("@function.builtin", "Function")
  link("@method", "Function")
  link("@constructor", "Function")
  link("@keyword", "Keyword")
  link("@operator", "Operator")
  link("@type", "Type")
  link("@type.builtin", "Type")
  link("@module", "Identifier")
  link("@punctuation", "Normal")

  link("@lsp.type.class", "Type")
  link("@lsp.type.decorator", "Function")
  link("@lsp.type.enum", "Type")
  link("@lsp.type.enumMember", "Constant")
  link("@lsp.type.event", "Type")
  link("@lsp.type.function", "Function")
  link("@lsp.type.interface", "Type")
  link("@lsp.type.keyword", "Keyword")
  link("@lsp.type.macro", "PreProc")
  link("@lsp.type.method", "Function")
  link("@lsp.type.modifier", "Keyword")
  link("@lsp.type.namespace", "Identifier")
  link("@lsp.type.number", "Number")
  link("@lsp.type.operator", "Operator")
  link("@lsp.type.parameter", "Identifier")
  link("@lsp.type.property", "Identifier")
  link("@lsp.type.string", "String")
  link("@lsp.type.struct", "Type")
  link("@lsp.type.type", "Type")
  link("@lsp.type.typeParameter", "Type")
  link("@lsp.type.variable", "Identifier")
  link("@lsp.mod.deprecated", "DiagnosticWarn")
end

apply()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = apply,
})
