-- High-contrast Darcula theme for AstroVim / Neovim.
-- Colorscheme name: intellij-dracula
-- Designed for distinct syntax categories, especially Python.

vim.cmd "hi clear"
if vim.fn.exists "syntax_on" == 1 then vim.cmd "syntax reset" end

vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "intellij-dracula"

local c = {
  -- Backgrounds: neutral charcoal with clearly separated UI surfaces.
  bg = "#20232D",
  bg_alt = "#191A21",
  bg_hl = "#292E3B",
  bg_float = "#242936",
  bg_popup = "#303849",
  bg_bar = "#252B38",
  bg_sel = "#354B70",
  bg_search = "#66502D",
  border = "#465166",

  -- Foregrounds.
  fg = "#F2F3F7",
  fg_soft = "#C7CDD8",
  fg_dim = "#929BAA",
  comment = "#9299A5",

  -- Syntax palette: each category has its own hue.
  pink = "#FF79C6", -- Keywords and control flow.
  yellow = "#FFD866", -- Functions and methods.
  cyan = "#8BE9FD", -- Classes and types.
  orange = "#FFB86C", -- Built-ins and special identifiers.
  purple = "#BD93F9", -- Parameters and selected constants.
  blue = "#82AAFF", -- Properties and attributes.
  green = "#A8E6A3", -- Strings and docstrings.
  peach = "#FF9E64", -- Numbers.
  lime = "#F1FA8C", -- Constants and booleans.
  coral = "#FF6B6B", -- Operators and errors.
  teal = "#64D8CB", -- Namespaces and modules.

  -- Diagnostics and Git.
  red = "#FF5555",
  warn = "#FFB86C",
  info = "#82AAFF",
  hint = "#BD93F9",
  add = "#A8E6A3",
  change = "#82AAFF",
  delete = "#FF6B6B",
}

local function hl(group, opts) vim.api.nvim_set_hl(0, group, opts) end

local groups = {
  -- Editor UI.
  Normal = { fg = c.fg, bg = c.bg },
  NormalNC = { fg = c.fg, bg = c.bg },
  NormalFloat = { fg = c.fg, bg = c.bg_float },
  FloatBorder = { fg = c.border, bg = c.bg_float },
  FloatTitle = { fg = c.yellow, bg = c.bg_float },
  FloatFooter = { fg = c.fg_dim, bg = c.bg_float },
  Cursor = { fg = c.bg, bg = c.cyan },
  CursorIM = { fg = c.bg, bg = c.cyan },
  CursorLine = { bg = c.bg_hl },
  CursorColumn = { bg = c.bg_hl },
  ColorColumn = { bg = c.bg_hl },
  CursorLineNr = { fg = c.yellow },
  LineNr = { fg = c.fg_dim },
  SignColumn = { bg = c.bg },
  FoldColumn = { fg = c.fg_dim, bg = c.bg },
  Folded = { fg = c.fg_soft, bg = c.bg_alt },
  VertSplit = { fg = c.border },
  WinSeparator = { fg = c.border },
  StatusLine = { fg = c.fg, bg = c.bg_bar },
  StatusLineNC = { fg = c.fg_dim, bg = c.bg_alt },
  TabLine = { fg = c.fg_dim, bg = c.bg_alt },
  TabLineSel = { fg = c.fg, bg = c.bg_bar },
  TabLineFill = { bg = c.bg },
  WinBar = { fg = c.fg_soft, bg = c.bg },
  WinBarNC = { fg = c.fg_dim, bg = c.bg },
  Visual = { bg = c.bg_sel },
  VisualNOS = { bg = c.bg_sel },
  Search = { fg = c.fg, bg = c.bg_search },
  IncSearch = { fg = c.bg, bg = c.yellow },
  CurSearch = { fg = c.bg, bg = c.yellow },
  Substitute = { fg = c.bg, bg = c.orange },
  MatchParen = { fg = c.yellow, bg = c.bg_popup, underline = true },
  Pmenu = { fg = c.fg, bg = c.bg_popup },
  PmenuSel = { fg = c.bg, bg = c.cyan },
  PmenuSbar = { bg = c.bg_bar },
  PmenuThumb = { bg = c.fg_dim },
  PmenuMatch = { fg = c.yellow },
  PmenuMatchSel = { fg = c.bg, bg = c.cyan },
  WildMenu = { fg = c.bg, bg = c.cyan },
  NonText = { fg = "#596273" },
  Whitespace = { fg = "#465064" },
  SpecialKey = { fg = "#68758A" },
  EndOfBuffer = { fg = c.bg },
  Conceal = { fg = c.fg_dim },
  Directory = { fg = c.cyan },
  Title = { fg = c.yellow },
  ErrorMsg = { fg = c.red },
  WarningMsg = { fg = c.warn },
  ModeMsg = { fg = c.cyan },
  MoreMsg = { fg = c.green },
  Question = { fg = c.cyan },
  QuickFixLine = { bg = c.bg_sel },
  SpellBad = { sp = c.red, undercurl = true },
  SpellCap = { sp = c.warn, undercurl = true },
  SpellLocal = { sp = c.info, undercurl = true },
  SpellRare = { sp = c.hint, undercurl = true },

  -- Legacy Vim syntax.
  Comment = { fg = c.comment, italic = true },
  Constant = { fg = c.lime },
  String = { fg = c.green },
  Character = { fg = c.green },
  Number = { fg = c.peach },
  Float = { fg = c.peach },
  Boolean = { fg = c.lime },
  Identifier = { fg = c.fg },
  Function = { fg = c.yellow },
  Statement = { fg = c.pink },
  Conditional = { fg = c.pink },
  Repeat = { fg = c.pink },
  Label = { fg = c.pink },
  Operator = { fg = c.coral },
  Keyword = { fg = c.pink },
  Exception = { fg = c.pink },
  PreProc = { fg = c.teal },
  Include = { fg = c.pink },
  Define = { fg = c.pink },
  Macro = { fg = c.teal },
  PreCondit = { fg = c.pink },
  Type = { fg = c.cyan },
  StorageClass = { fg = c.pink },
  Structure = { fg = c.cyan },
  Typedef = { fg = c.cyan },
  Special = { fg = c.orange },
  SpecialChar = { fg = c.orange },
  Tag = { fg = c.pink },
  Delimiter = { fg = c.fg_soft },
  SpecialComment = { fg = c.teal, italic = true },
  Debug = { fg = c.coral },
  Underlined = { fg = c.blue, underline = true },
  Error = { fg = c.red, undercurl = true },
  Todo = { fg = c.bg, bg = c.yellow },

  -- Tree-sitter: core captures.
  ["@comment"] = { fg = c.comment, italic = true },
  ["@comment.documentation"] = { fg = c.green, italic = true },
  ["@comment.todo"] = { fg = c.bg, bg = c.yellow },
  ["@comment.warning"] = { fg = c.bg, bg = c.warn },
  ["@comment.error"] = { fg = c.bg, bg = c.red },
  ["@comment.note"] = { fg = c.bg, bg = c.info },

  ["@variable"] = { fg = c.fg },
  ["@variable.builtin"] = { fg = c.orange, italic = true },
  ["@variable.parameter"] = { fg = c.purple },
  ["@variable.member"] = { fg = c.blue },
  ["@variable.parameter.builtin"] = { fg = c.orange, italic = true },

  ["@constant"] = { fg = c.lime },
  ["@constant.builtin"] = { fg = c.lime },
  ["@constant.macro"] = { fg = c.orange },
  ["@module"] = { fg = c.teal },
  ["@namespace"] = { fg = c.teal },
  ["@label"] = { fg = c.pink },

  ["@string"] = { fg = c.green },
  ["@string.documentation"] = { fg = c.green, italic = true },
  ["@string.escape"] = { fg = c.orange },
  ["@string.regexp"] = { fg = c.peach },
  ["@string.special"] = { fg = c.orange },
  ["@string.interpolation"] = { fg = c.yellow },
  ["@string.special.url"] = { fg = c.blue, underline = true },
  ["@character"] = { fg = c.green },
  ["@number"] = { fg = c.peach },
  ["@number.float"] = { fg = c.peach },
  ["@boolean"] = { fg = c.lime },

  ["@type"] = { fg = c.cyan },
  ["@type.builtin"] = { fg = c.cyan },
  ["@type.definition"] = { fg = c.cyan },
  ["@attribute"] = { fg = c.blue },
  ["@property"] = { fg = c.blue },
  ["@function"] = { fg = c.yellow },
  ["@function.builtin"] = { fg = c.orange },
  ["@function.call"] = { fg = c.yellow },
  ["@function.macro"] = { fg = c.teal },
  ["@function.method"] = { fg = c.yellow },
  ["@function.method.call"] = { fg = c.yellow },
  ["@constructor"] = { fg = c.cyan },

  ["@operator"] = { fg = c.coral },
  ["@keyword"] = { fg = c.pink },
  ["@keyword.function"] = { fg = c.pink },
  ["@keyword.return"] = { fg = c.pink },
  ["@keyword.operator"] = { fg = c.pink },
  ["@keyword.import"] = { fg = c.pink },
  ["@keyword.conditional"] = { fg = c.pink },
  ["@keyword.repeat"] = { fg = c.pink },
  ["@keyword.exception"] = { fg = c.pink },
  ["@keyword.coroutine"] = { fg = c.pink },
  ["@keyword.directive"] = { fg = c.teal },

  ["@punctuation"] = { fg = c.fg_soft },
  ["@punctuation.delimiter"] = { fg = c.fg_soft },
  ["@punctuation.bracket"] = { fg = c.cyan },
  ["@punctuation.special"] = { fg = c.orange },

  -- Markup and embedded languages.
  ["@tag"] = { fg = c.pink },
  ["@tag.attribute"] = { fg = c.blue },
  ["@tag.delimiter"] = { fg = c.fg_soft },
  ["@markup.heading"] = { fg = c.yellow },
  ["@markup.strong"] = { fg = c.fg },
  ["@markup.italic"] = { fg = c.purple, italic = true },
  ["@markup.strikethrough"] = { fg = c.fg_dim, strikethrough = true },
  ["@markup.underline"] = { underline = true },
  ["@markup.link"] = { fg = c.blue, underline = true },
  ["@markup.link.url"] = { fg = c.teal, underline = true },
  ["@markup.raw"] = { fg = c.green },
  ["@markup.list"] = { fg = c.pink },
  ["@markup.quote"] = { fg = c.comment, italic = true },
  ["@diff.plus"] = { fg = c.add },
  ["@diff.minus"] = { fg = c.delete },
  ["@diff.delta"] = { fg = c.change },
  ["@property.css"] = { fg = c.blue },
  ["@property.json"] = { fg = c.purple },

  -- Python-specific Tree-sitter captures.
  ["@variable.builtin.python"] = { fg = c.orange, italic = true },
  ["@function.builtin.python"] = { fg = c.orange },
  ["@type.builtin.python"] = { fg = c.cyan },
  ["@attribute.python"] = { fg = c.blue },
  ["@string.documentation.python"] = { fg = c.green, italic = true },

  -- LSP semantic tokens. These keep colors distinct when semantic
  -- highlighting is enabled by basedpyright or another language server.
  ["@lsp.type.class"] = { fg = c.cyan },
  ["@lsp.type.decorator"] = { fg = c.blue },
  ["@lsp.type.enum"] = { fg = c.cyan },
  ["@lsp.type.enumMember"] = { fg = c.lime },
  ["@lsp.type.function"] = { fg = c.yellow },
  ["@lsp.type.interface"] = { fg = c.cyan },
  ["@lsp.type.keyword"] = { fg = c.pink },
  ["@lsp.type.macro"] = { fg = c.teal },
  ["@lsp.type.method"] = { fg = c.yellow },
  ["@lsp.type.namespace"] = { fg = c.teal },
  ["@lsp.type.number"] = { fg = c.peach },
  ["@lsp.type.operator"] = { fg = c.coral },
  ["@lsp.type.parameter"] = { fg = c.purple },
  ["@lsp.type.property"] = { fg = c.blue },
  ["@lsp.type.string"] = { fg = c.green },
  ["@lsp.type.struct"] = { fg = c.cyan },
  ["@lsp.type.type"] = { fg = c.cyan },
  ["@lsp.type.typeParameter"] = { fg = c.cyan, italic = true },
  ["@lsp.type.variable"] = { fg = c.fg },
  ["@lsp.typemod.variable.readonly"] = { fg = c.lime },
  ["@lsp.typemod.variable.static"] = { fg = c.purple },
  ["@lsp.typemod.function.defaultLibrary"] = { fg = c.orange },
  ["@lsp.typemod.method.defaultLibrary"] = { fg = c.orange },

  -- Diagnostics and references.
  DiagnosticError = { fg = c.red },
  DiagnosticWarn = { fg = c.warn },
  DiagnosticInfo = { fg = c.info },
  DiagnosticHint = { fg = c.hint },
  DiagnosticOk = { fg = c.add },
  DiagnosticUnderlineError = { sp = c.red, undercurl = true },
  DiagnosticUnderlineWarn = { sp = c.warn, undercurl = true },
  DiagnosticUnderlineInfo = { sp = c.info, undercurl = true },
  DiagnosticUnderlineHint = { sp = c.hint, undercurl = true },
  DiagnosticVirtualTextError = { fg = c.red, bg = "#38252D" },
  DiagnosticVirtualTextWarn = { fg = c.warn, bg = "#393025" },
  DiagnosticVirtualTextInfo = { fg = c.info, bg = "#252F43" },
  DiagnosticVirtualTextHint = { fg = c.hint, bg = "#30283F" },
  LspReferenceText = { bg = "#343D50" },
  LspReferenceRead = { bg = "#343D50" },
  LspReferenceWrite = { bg = "#493D5E" },
  LspInlayHint = { fg = c.fg_dim, bg = c.bg_alt, italic = true },
  LspCodeLens = { fg = c.fg_dim, italic = true },

  -- Diff and Git.
  DiffAdd = { bg = "#263A32" },
  DiffChange = { bg = "#263449" },
  DiffDelete = { bg = "#442A32" },
  DiffText = { bg = "#3B4D6B" },
  Added = { fg = c.add },
  Changed = { fg = c.change },
  Removed = { fg = c.delete },
  GitSignsAdd = { fg = c.add },
  GitSignsChange = { fg = c.change },
  GitSignsDelete = { fg = c.delete },

  -- Telescope, Snacks, and pickers.
  TelescopeNormal = { fg = c.fg, bg = c.bg_float },
  TelescopeBorder = { fg = c.border, bg = c.bg_float },
  TelescopeSelection = { fg = c.fg, bg = c.bg_sel },
  TelescopeMatching = { fg = c.yellow },
  SnacksPickerMatch = { fg = c.yellow },
  SnacksPickerDir = { fg = c.cyan },
  SnacksIndent = { fg = "#394354" },
  SnacksIndentScope = { fg = c.purple },

  -- Completion menus.
  CmpItemAbbrMatch = { fg = c.yellow },
  CmpItemAbbrMatchFuzzy = { fg = c.yellow },
  CmpItemKindFunction = { fg = c.yellow },
  CmpItemKindMethod = { fg = c.yellow },
  CmpItemKindVariable = { fg = c.fg },
  CmpItemKindKeyword = { fg = c.pink },
  CmpItemKindClass = { fg = c.cyan },
  CmpItemKindProperty = { fg = c.blue },
  BlinkCmpMenu = { fg = c.fg, bg = c.bg_popup },
  BlinkCmpMenuSelection = { fg = c.bg, bg = c.cyan },
  BlinkCmpLabelMatch = { fg = c.yellow },

  -- Miscellaneous plugins.
  NeoTreeNormal = { fg = c.fg, bg = c.bg },
  NeoTreeNormalNC = { fg = c.fg, bg = c.bg },
  NeoTreeDirectoryName = { fg = c.cyan },
  NeoTreeDirectoryIcon = { fg = c.blue },
  NeoTreeRootName = { fg = c.yellow },
  WhichKey = { fg = c.yellow },
  WhichKeyDesc = { fg = c.fg },
  WhichKeyGroup = { fg = c.pink },
  WhichKeySeparator = { fg = c.fg_dim },
  IndentBlanklineChar = { fg = "#394354" },
  MiniIndentscopeSymbol = { fg = c.purple },
  FlashLabel = { fg = c.bg, bg = c.yellow },
  FlashMatch = { fg = c.fg, bg = c.bg_sel },
  FlashCurrent = { fg = c.bg, bg = c.cyan },
  LazyNormal = { fg = c.fg, bg = c.bg_float },
  MasonNormal = { fg = c.fg, bg = c.bg_float },
  NoiceCmdlinePopup = { fg = c.fg, bg = c.bg_float },
  NotifyBackground = { bg = c.bg_float },
  TreesitterContext = { bg = c.bg_alt },
  RenderMarkdownCode = { bg = c.bg_alt },
}

for group, opts in pairs(groups) do
  hl(group, opts)
end

-- Terminal palette, aligned with the editor syntax colors.
vim.g.terminal_color_0 = c.bg
vim.g.terminal_color_1 = c.red
vim.g.terminal_color_2 = c.green
vim.g.terminal_color_3 = c.yellow
vim.g.terminal_color_4 = c.blue
vim.g.terminal_color_5 = c.purple
vim.g.terminal_color_6 = c.cyan
vim.g.terminal_color_7 = c.fg_soft
vim.g.terminal_color_8 = c.fg_dim
vim.g.terminal_color_9 = "#FF6E6E"
vim.g.terminal_color_10 = "#B8F2B0"
vim.g.terminal_color_11 = "#FFF19A"
vim.g.terminal_color_12 = "#A4C2FF"
vim.g.terminal_color_13 = "#D0A9FF"
vim.g.terminal_color_14 = "#8DECE0"
vim.g.terminal_color_15 = "#FFFFFF"
