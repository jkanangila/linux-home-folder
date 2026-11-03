-- One Dark Pro-inspired colorscheme for AstroVim / Neovim.
-- Uses the classic One Dark Pro palette from Binaryify/OneDark-Pro.
-- Colorscheme name: intellij-onedarkpro

vim.cmd "hi clear"
if vim.fn.exists "syntax_on" == 1 then vim.cmd "syntax reset" end

vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "intellij-onedarkpro"

local c = {
  -- Classic One Dark Pro base palette.
  bg = "#282C34",
  bg_dark = "#21252B",
  bg_darker = "#181A1F",
  bg_float = "#21252B",
  bg_popup = "#2C313A",
  bg_hl = "#2C313A",
  bg_sel = "#3E4451",
  bg_visual = "#3E4451",
  border = "#3B4048",

  fg = "#ABB2BF",
  fg_bright = "#C8CCD4",
  fg_dim = "#7F848E",
  comment = "#5C6370",

  -- One Dark Pro syntax colors.
  red = "#E06C75",
  red_bright = "#E05561",
  dark_red = "#BE5046",
  orange = "#D19A66",
  yellow = "#E5C07B",
  green = "#98C379",
  blue = "#61AFEF",
  blue_bright = "#4AA5F0",
  purple = "#C678DD",
  purple_bright = "#D55FDE",
  cyan = "#56B6C2",
  cyan_bright = "#2BBAC5",

  -- UI / diagnostic aliases.
  error = "#F44747",
  warn = "#D19A66",
  info = "#61AFEF",
  hint = "#C678DD",
  add = "#98C379",
  change = "#61AFEF",
  delete = "#E06C75",
}

local function hl(group, opts) vim.api.nvim_set_hl(0, group, opts) end

local groups = {
  -- Editor UI.
  Normal = { fg = c.fg, bg = c.bg },
  NormalNC = { fg = c.fg, bg = c.bg },
  NormalFloat = { fg = c.fg, bg = c.bg_float },
  FloatBorder = { fg = c.fg_dim, bg = c.bg_float },
  FloatTitle = { fg = c.yellow, bg = c.bg_float, bold = true },
  FloatFooter = { fg = c.fg_dim, bg = c.bg_float },
  Cursor = { fg = c.bg, bg = c.blue },
  CursorIM = { fg = c.bg, bg = c.blue },
  CursorLine = { bg = c.bg_hl },
  CursorColumn = { bg = c.bg_hl },
  ColorColumn = { bg = c.bg_hl },
  CursorLineNr = { fg = c.yellow, bold = true },
  LineNr = { fg = c.fg_dim },
  SignColumn = { bg = c.bg },
  FoldColumn = { fg = c.fg_dim, bg = c.bg },
  Folded = { fg = c.fg, bg = c.bg_dark },
  VertSplit = { fg = c.border },
  WinSeparator = { fg = c.border },
  StatusLine = { fg = c.fg, bg = c.bg_dark },
  StatusLineNC = { fg = c.fg_dim, bg = c.bg_darker },
  TabLine = { fg = c.fg_dim, bg = c.bg_dark },
  TabLineSel = { fg = c.fg_bright, bg = c.bg, bold = true },
  TabLineFill = { bg = c.bg_dark },
  WinBar = { fg = c.fg, bg = c.bg },
  WinBarNC = { fg = c.fg_dim, bg = c.bg },
  Visual = { bg = c.bg_visual },
  VisualNOS = { bg = c.bg_visual },
  Search = { fg = c.bg, bg = c.yellow },
  IncSearch = { fg = c.bg, bg = c.orange, bold = true },
  CurSearch = { fg = c.bg, bg = c.yellow, bold = true },
  Substitute = { fg = c.bg, bg = c.red },
  MatchParen = { fg = c.yellow, bg = c.bg_sel, bold = true },
  Pmenu = { fg = c.fg, bg = c.bg_popup },
  PmenuSel = { fg = c.bg, bg = c.blue, bold = true },
  PmenuSbar = { bg = c.bg_dark },
  PmenuThumb = { bg = c.fg_dim },
  PmenuMatch = { fg = c.yellow, bold = true },
  PmenuMatchSel = { fg = c.bg, bg = c.blue, bold = true },
  WildMenu = { fg = c.bg, bg = c.blue, bold = true },
  NonText = { fg = c.comment },
  Whitespace = { fg = c.border },
  SpecialKey = { fg = c.fg_dim },
  EndOfBuffer = { fg = c.bg },
  Conceal = { fg = c.fg_dim },
  Directory = { fg = c.blue },
  Title = { fg = c.yellow, bold = true },
  ErrorMsg = { fg = c.red, bold = true },
  WarningMsg = { fg = c.orange, bold = true },
  ModeMsg = { fg = c.green },
  MoreMsg = { fg = c.green },
  Question = { fg = c.blue },
  QuickFixLine = { bg = c.bg_sel },
  SpellBad = { sp = c.red, undercurl = true },
  SpellCap = { sp = c.yellow, undercurl = true },
  SpellLocal = { sp = c.blue, undercurl = true },
  SpellRare = { sp = c.purple, undercurl = true },

  -- Legacy Vim syntax.
  Comment = { fg = c.comment, italic = true },
  Constant = { fg = c.orange },
  String = { fg = c.green },
  Character = { fg = c.green },
  Number = { fg = c.orange },
  Float = { fg = c.orange },
  Boolean = { fg = c.orange },
  Identifier = { fg = c.red },
  Function = { fg = c.blue },
  Statement = { fg = c.purple },
  Conditional = { fg = c.purple },
  Repeat = { fg = c.purple },
  Label = { fg = c.purple },
  Operator = { fg = c.fg },
  Keyword = { fg = c.purple },
  Exception = { fg = c.purple },
  PreProc = { fg = c.purple },
  Include = { fg = c.purple },
  Define = { fg = c.purple },
  Macro = { fg = c.orange },
  PreCondit = { fg = c.purple },
  Type = { fg = c.yellow },
  StorageClass = { fg = c.purple },
  Structure = { fg = c.yellow },
  Typedef = { fg = c.yellow },
  Special = { fg = c.red },
  SpecialChar = { fg = c.red },
  Tag = { fg = c.red },
  Delimiter = { fg = c.fg },
  SpecialComment = { fg = c.comment, italic = true },
  Debug = { fg = c.red },
  Underlined = { fg = c.blue, underline = true },
  Error = { fg = c.red, undercurl = true },
  Todo = { fg = c.bg, bg = c.yellow, bold = true },

  -- Tree-sitter: base captures.
  ["@comment"] = { fg = c.comment, italic = true },
  ["@comment.documentation"] = { fg = c.comment, italic = true },
  ["@comment.todo"] = { fg = c.bg, bg = c.yellow, bold = true },
  ["@comment.warning"] = { fg = c.bg, bg = c.orange, bold = true },
  ["@comment.error"] = { fg = c.bg, bg = c.red, bold = true },
  ["@comment.note"] = { fg = c.bg, bg = c.blue, bold = true },

  ["@variable"] = { fg = c.fg },
  ["@variable.builtin"] = { fg = c.red },
  ["@variable.parameter"] = { fg = c.red },
  ["@variable.member"] = { fg = c.red },
  ["@variable.parameter.builtin"] = { fg = c.yellow },

  ["@constant"] = { fg = c.orange },
  ["@constant.builtin"] = { fg = c.orange },
  ["@constant.macro"] = { fg = c.orange },
  ["@module"] = { fg = c.fg },
  ["@namespace"] = { fg = c.fg },
  ["@label"] = { fg = c.red },

  ["@string"] = { fg = c.green },
  ["@string.documentation"] = { fg = c.green, italic = true },
  ["@string.escape"] = { fg = c.red },
  ["@string.regexp"] = { fg = c.orange },
  ["@string.special"] = { fg = c.orange },
  ["@string.interpolation"] = { fg = c.yellow },
  ["@string.special.url"] = { fg = c.blue, underline = true },
  ["@character"] = { fg = c.green },
  ["@number"] = { fg = c.orange },
  ["@number.float"] = { fg = c.orange },
  ["@boolean"] = { fg = c.orange },

  ["@type"] = { fg = c.yellow },
  ["@type.builtin"] = { fg = c.yellow },
  ["@type.definition"] = { fg = c.yellow },
  ["@attribute"] = { fg = c.orange },
  ["@property"] = { fg = c.red },
  ["@function"] = { fg = c.blue },
  ["@function.builtin"] = { fg = c.blue },
  ["@function.call"] = { fg = c.blue },
  ["@function.macro"] = { fg = c.purple },
  ["@function.method"] = { fg = c.blue },
  ["@function.method.call"] = { fg = c.blue },
  ["@constructor"] = { fg = c.yellow },

  ["@operator"] = { fg = c.fg },
  ["@keyword"] = { fg = c.purple },
  ["@keyword.function"] = { fg = c.purple },
  ["@keyword.return"] = { fg = c.purple },
  ["@keyword.operator"] = { fg = c.purple },
  ["@keyword.import"] = { fg = c.purple },
  ["@keyword.conditional"] = { fg = c.purple },
  ["@keyword.repeat"] = { fg = c.purple },
  ["@keyword.exception"] = { fg = c.purple },
  ["@keyword.coroutine"] = { fg = c.purple },
  ["@keyword.directive"] = { fg = c.purple },

  ["@punctuation"] = { fg = c.fg },
  ["@punctuation.delimiter"] = { fg = c.fg },
  ["@punctuation.bracket"] = { fg = c.fg },
  ["@punctuation.special"] = { fg = c.red },

  -- Markup and embedded languages.
  ["@tag"] = { fg = c.red },
  ["@tag.attribute"] = { fg = c.orange },
  ["@tag.delimiter"] = { fg = c.fg },
  ["@markup.heading"] = { fg = c.red, bold = true },
  ["@markup.strong"] = { fg = c.fg, bold = true },
  ["@markup.italic"] = { fg = c.fg, italic = true },
  ["@markup.strikethrough"] = { fg = c.fg_dim, strikethrough = true },
  ["@markup.underline"] = { underline = true },
  ["@markup.link"] = { fg = c.blue, underline = true },
  ["@markup.link.url"] = { fg = c.cyan, underline = true },
  ["@markup.raw"] = { fg = c.green },
  ["@markup.list"] = { fg = c.red },
  ["@markup.quote"] = { fg = c.comment, italic = true },
  ["@diff.plus"] = { fg = c.green },
  ["@diff.minus"] = { fg = c.red },
  ["@diff.delta"] = { fg = c.blue },
  ["@property.css"] = { fg = c.red },
  ["@property.json"] = { fg = c.red },

  -- Python-specific captures.
  ["@variable.builtin.python"] = { fg = c.red },
  ["@function.builtin.python"] = { fg = c.blue },
  ["@type.builtin.python"] = { fg = c.yellow },
  ["@attribute.python"] = { fg = c.orange },
  ["@string.documentation.python"] = { fg = c.green, italic = true },

  -- LSP semantic tokens. basedpyright/Pylance-compatible categories.
  ["@lsp.type.class"] = { fg = c.yellow },
  ["@lsp.type.decorator"] = { fg = c.orange },
  ["@lsp.type.enum"] = { fg = c.yellow },
  ["@lsp.type.enumMember"] = { fg = c.cyan },
  ["@lsp.type.function"] = { fg = c.blue },
  ["@lsp.type.interface"] = { fg = c.yellow },
  ["@lsp.type.keyword"] = { fg = c.purple },
  ["@lsp.type.macro"] = { fg = c.orange },
  ["@lsp.type.method"] = { fg = c.blue },
  ["@lsp.type.namespace"] = { fg = c.fg },
  ["@lsp.type.number"] = { fg = c.orange },
  ["@lsp.type.operator"] = { fg = c.fg },
  ["@lsp.type.parameter"] = { fg = c.red },
  ["@lsp.type.property"] = { fg = c.red },
  ["@lsp.type.string"] = { fg = c.green },
  ["@lsp.type.struct"] = { fg = c.yellow },
  ["@lsp.type.type"] = { fg = c.yellow },
  ["@lsp.type.typeParameter"] = { fg = c.yellow },
  ["@lsp.type.variable"] = { fg = c.fg },
  ["@lsp.typemod.variable.readonly"] = { fg = c.orange },
  ["@lsp.typemod.variable.static"] = { fg = c.orange },
  ["@lsp.typemod.function.defaultLibrary"] = { fg = c.blue },
  ["@lsp.typemod.method.defaultLibrary"] = { fg = c.blue },

  -- Diagnostics and references.
  DiagnosticError = { fg = c.red },
  DiagnosticWarn = { fg = c.orange },
  DiagnosticInfo = { fg = c.blue },
  DiagnosticHint = { fg = c.purple },
  DiagnosticOk = { fg = c.green },
  DiagnosticUnderlineError = { sp = c.red, undercurl = true },
  DiagnosticUnderlineWarn = { sp = c.orange, undercurl = true },
  DiagnosticUnderlineInfo = { sp = c.blue, undercurl = true },
  DiagnosticUnderlineHint = { sp = c.purple, undercurl = true },
  DiagnosticVirtualTextError = { fg = c.red, bg = "#3A292D" },
  DiagnosticVirtualTextWarn = { fg = c.orange, bg = "#3A3028" },
  DiagnosticVirtualTextInfo = { fg = c.blue, bg = "#273442" },
  DiagnosticVirtualTextHint = { fg = c.purple, bg = "#342A3A" },
  LspReferenceText = { bg = c.bg_sel },
  LspReferenceRead = { bg = c.bg_sel },
  LspReferenceWrite = { bg = "#4A3B50", bold = true },
  LspInlayHint = { fg = c.fg_dim, bg = c.bg_dark, italic = true },
  LspCodeLens = { fg = c.fg_dim, italic = true },

  -- Diff and Git.
  DiffAdd = { bg = "#2B3A30" },
  DiffChange = { bg = "#2B3545" },
  DiffDelete = { bg = "#3B2B30" },
  DiffText = { bg = "#3A4558", bold = true },
  Added = { fg = c.green },
  Changed = { fg = c.blue },
  Removed = { fg = c.red },
  GitSignsAdd = { fg = c.green },
  GitSignsChange = { fg = c.blue },
  GitSignsDelete = { fg = c.red },

  -- Telescope / Snacks pickers.
  TelescopeNormal = { fg = c.fg, bg = c.bg_float },
  TelescopeBorder = { fg = c.fg_dim, bg = c.bg_float },
  TelescopeSelection = { fg = c.fg_bright, bg = c.bg_sel },
  TelescopeMatching = { fg = c.orange, bold = true },
  SnacksPickerMatch = { fg = c.orange, bold = true },
  SnacksPickerDir = { fg = c.blue },
  SnacksIndent = { fg = c.border },
  SnacksIndentScope = { fg = c.purple },

  -- Completion menus.
  CmpItemAbbrMatch = { fg = c.orange, bold = true },
  CmpItemAbbrMatchFuzzy = { fg = c.orange, bold = true },
  CmpItemKindFunction = { fg = c.blue },
  CmpItemKindMethod = { fg = c.blue },
  CmpItemKindVariable = { fg = c.fg },
  CmpItemKindKeyword = { fg = c.purple },
  CmpItemKindClass = { fg = c.yellow },
  CmpItemKindProperty = { fg = c.red },
  BlinkCmpMenu = { fg = c.fg, bg = c.bg_popup },
  BlinkCmpMenuSelection = { fg = c.bg, bg = c.blue, bold = true },
  BlinkCmpLabelMatch = { fg = c.orange, bold = true },

  -- Common plugin UI.
  NeoTreeNormal = { fg = c.fg, bg = c.bg },
  NeoTreeNormalNC = { fg = c.fg, bg = c.bg },
  NeoTreeDirectoryName = { fg = c.blue },
  NeoTreeDirectoryIcon = { fg = c.blue },
  NeoTreeRootName = { fg = c.yellow, bold = true },
  WhichKey = { fg = c.yellow, bold = true },
  WhichKeyDesc = { fg = c.fg },
  WhichKeyGroup = { fg = c.purple },
  WhichKeySeparator = { fg = c.fg_dim },
  IndentBlanklineChar = { fg = c.border },
  MiniIndentscopeSymbol = { fg = c.purple },
  FlashLabel = { fg = c.bg, bg = c.yellow, bold = true },
  FlashMatch = { fg = c.fg, bg = c.bg_sel },
  FlashCurrent = { fg = c.bg, bg = c.blue, bold = true },
  LazyNormal = { fg = c.fg, bg = c.bg_float },
  MasonNormal = { fg = c.fg, bg = c.bg_float },
  NoiceCmdlinePopup = { fg = c.fg, bg = c.bg_float },
  NotifyBackground = { bg = c.bg_float },
  TreesitterContext = { bg = c.bg_dark },
  RenderMarkdownCode = { bg = c.bg_dark },
}

for group, opts in pairs(groups) do
  hl(group, opts)
end

-- Terminal ANSI colors.
vim.g.terminal_color_0 = c.bg_dark
vim.g.terminal_color_1 = c.red
vim.g.terminal_color_2 = c.green
vim.g.terminal_color_3 = c.yellow
vim.g.terminal_color_4 = c.blue
vim.g.terminal_color_5 = c.purple
vim.g.terminal_color_6 = c.cyan
vim.g.terminal_color_7 = c.fg
vim.g.terminal_color_8 = c.fg_dim
vim.g.terminal_color_9 = c.red_bright
vim.g.terminal_color_10 = "#A5D184"
vim.g.terminal_color_11 = "#EBCB8B"
vim.g.terminal_color_12 = c.blue_bright
vim.g.terminal_color_13 = c.purple_bright
vim.g.terminal_color_14 = c.cyan_bright
vim.g.terminal_color_15 = c.fg_bright
