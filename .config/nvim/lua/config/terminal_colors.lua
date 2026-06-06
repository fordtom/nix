local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

local function link(group, target)
  hl(group, { link = target })
end

local function link_capture(group, target, languages)
  link(group, target)

  for _, language in ipairs(languages or {}) do
    link(group .. "." .. language, target)
  end
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
  hl("String", { ctermfg = 13 })
  hl("Character", { ctermfg = 13 })
  hl("Number", { ctermfg = 11 })
  hl("Boolean", { ctermfg = 11 })
  hl("Float", { ctermfg = 11 })
  hl("Identifier", { ctermfg = 7 })
  hl("Function", { ctermfg = 3, bold = true })
  hl("Statement", { ctermfg = 14 })
  hl("Keyword", { ctermfg = 14 })
  hl("Operator", { ctermfg = 6 })
  hl("PreProc", { ctermfg = 14 })
  hl("Type", { ctermfg = 3 })
  hl("Special", { ctermfg = 14 })
  hl("Constant", { ctermfg = 13 })
  hl("ConfigNixAttribute", { ctermfg = 5 })

  hl("DiagnosticError", { ctermfg = 9 })
  hl("DiagnosticWarn", { ctermfg = 11 })
  hl("DiagnosticInfo", { ctermfg = 12 })
  hl("DiagnosticHint", { ctermfg = 14 })
  hl("DiagnosticOk", { ctermfg = 10 })

  link_capture("@comment", "Comment")
  link_capture("@string", "String")
  link_capture("@string.special", "Special", { "markdown", "markdown_inline" })
  link_capture("@string.escape", "Special", { "markdown", "markdown_inline" })
  link_capture("@character", "Character")
  link_capture("@character.special", "Special", { "markdown", "markdown_inline" })
  link_capture("@boolean", "Boolean")
  link_capture("@number", "Number")
  link_capture("@number.float", "Float")
  link_capture("@constant", "Constant")
  link_capture("@constant.builtin", "Constant")
  link_capture("@variable", "Normal")
  link_capture("@variable.builtin", "Special")
  link_capture("@variable.parameter", "Identifier")
  link_capture("@property", "Special")
  link_capture("@field", "Special")
  link_capture("@function", "Function")
  link_capture("@function.builtin", "Function")
  link_capture("@method", "Function")
  link_capture("@constructor", "Function")
  link_capture("@keyword", "Keyword")
  link_capture("@keyword.directive", "Keyword", { "markdown" })
  link_capture("@operator", "Operator")
  link_capture("@type", "Type")
  link_capture("@type.builtin", "Type")
  link_capture("@module", "Identifier")
  link_capture("@label", "Special", { "markdown" })
  link_capture("@punctuation", "Normal")
  link_capture("@punctuation.delimiter", "Normal", { "markdown" })
  link_capture("@punctuation.special", "Special", { "markdown" })

  link_capture("@markup.heading", "Function", { "markdown" })
  link_capture("@markup.heading.1", "Function", { "markdown" })
  link_capture("@markup.heading.2", "Function", { "markdown" })
  link_capture("@markup.heading.3", "Function", { "markdown" })
  link_capture("@markup.heading.4", "Function", { "markdown" })
  link_capture("@markup.heading.5", "Function", { "markdown" })
  link_capture("@markup.heading.6", "Function", { "markdown" })
  link_capture("@markup.strong", "Statement", { "markdown_inline" })
  link_capture("@markup.italic", "Comment", { "markdown_inline" })
  link_capture("@markup.strikethrough", "Comment", { "markdown_inline" })
  link_capture("@markup.link", "Special", { "markdown_inline" })
  link_capture("@markup.link.label", "Special", { "markdown", "markdown_inline" })
  link_capture("@markup.link.url", "String", { "markdown", "markdown_inline" })
  link_capture("@markup.raw", "String", { "markdown_inline" })
  link_capture("@markup.raw.block", "String", { "markdown" })
  link_capture("@markup.list", "Constant", { "markdown" })
  link_capture("@markup.list.checked", "Constant", { "markdown" })
  link_capture("@markup.list.unchecked", "Constant", { "markdown" })
  link_capture("@markup.quote", "Comment", { "markdown" })

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
  link("@lsp.type.namespace", "Type")
  link("@lsp.type.number", "Number")
  link("@lsp.type.operator", "Operator")
  link("@lsp.type.parameter", "Identifier")
  link("@lsp.type.property", "Special")
  link("@lsp.type.string", "String")
  link("@lsp.type.struct", "Type")
  link("@lsp.type.type", "Type")
  link("@lsp.type.typeParameter", "Type")
  link("@lsp.type.variable", "Normal")
  link("@lsp.mod.deprecated", "DiagnosticWarn")

  link("zigBuiltinFn", "Function")
  link("rustModPath", "Type")
  link("pythonBuiltin", "Keyword")
  link("nixArgumentDefinition", "ConfigNixAttribute")
  link("nixAttribute", "ConfigNixAttribute")
  link("nixSimpleFunctionArgument", "ConfigNixAttribute")
end

apply()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = apply,
})
