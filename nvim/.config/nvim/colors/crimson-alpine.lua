-- Crimson Alpine
-- High-contrast red / charcoal / ivory theme for AstroVim.
-- Designed for Python, Tree-sitter and LSP semantic highlighting.

vim.cmd "hi clear"
if vim.fn.exists "syntax_on" == 1 then vim.cmd "syntax reset" end

vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "crimson-alpine"

local c = {
  -- Reference palette
  burgundy = "#380F17",
  crimson = "#8F0B13",
  red = "#DC2011",
  ivory = "#EFDFC5",
  charcoal = "#252B2B",
  slate = "#4C4F54",

  -- UI surfaces
  bg = "#252B2B",
  bg_alt = "#380F17",
  bg_hl = "#380F17",
  bg_float = "#252B2B",
  bg_popup = "#4C4F54",
  bg_bar = "#380F17",
  bg_sel = "#8F0B13",
  bg_search = "#DC2011",
  border = "#4C4F54",

  -- Foregrounds
  fg = "#EFDFC5",
  fg_soft = "#EFDFC5",
  fg_dim = "#4C4F54",
  comment = "#4C4F54",

  -- Syntax
  keyword = "#8F0B13",
  function_ = "#DC2011",
  type = "#EFDFC5",
  string = "#EFDFC5",
  parameter = "#DC2011",
  property = "#EFDFC5",
  builtin = "#DC2011",
  number = "#DC2011",
  operator = "#8F0B13",
  constant = "#DC2011",
  namespace = "#EFDFC5",

  -- Diagnostics and Git
  error = "#DC2011",
  warn = "#DC2011",
  info = "#EFDFC5",
  hint = "#4C4F54",
  add = "#EFDFC5",
  change = "#DC2011",
  delete = "#8F0B13",
}

local function hl(group, opts) vim.api.nvim_set_hl(0, group, opts) end

local groups = {
  -- ============================================================
  -- EDITOR UI
  -- ============================================================

  Normal = { fg = c.fg, bg = c.bg },
  NormalNC = { fg = c.fg, bg = c.bg },
  NormalFloat = { fg = c.fg, bg = c.bg_float },
  FloatBorder = { fg = c.slate, bg = c.bg_float },
  FloatTitle = { fg = c.red, bg = c.bg_float, bold = true },
  FloatFooter = { fg = c.ivory, bg = c.bg_float },

  Cursor = { fg = c.charcoal, bg = c.red },
  CursorIM = { fg = c.charcoal, bg = c.red },
  CursorLine = { bg = c.bg_alt },
  CursorColumn = { bg = c.bg_alt },
  ColorColumn = { bg = c.bg_alt },

  CursorLineNr = { fg = c.red, bold = true },
  LineNr = { fg = c.slate },
  SignColumn = { bg = c.bg },
  FoldColumn = { fg = c.slate, bg = c.bg },
  Folded = { fg = c.ivory, bg = c.burgundy },

  VertSplit = { fg = c.slate },
  WinSeparator = { fg = c.slate },

  StatusLine = { fg = c.ivory, bg = c.burgundy },
  StatusLineNC = { fg = c.ivory, bg = c.charcoal },
  TabLine = { fg = c.slate, bg = c.burgundy },
  TabLineSel = { fg = c.ivory, bg = c.crimson, bold = true },
  TabLineFill = { bg = c.bg },

  WinBar = { fg = c.ivory, bg = c.bg },
  WinBarNC = { fg = c.slate, bg = c.bg },

  Visual = { bg = c.crimson },
  VisualNOS = { bg = c.crimson },

  Search = { fg = c.ivory, bg = c.crimson, bold = true },
  IncSearch = { fg = c.charcoal, bg = c.red, bold = true },
  CurSearch = { fg = c.charcoal, bg = c.red, bold = true },
  Substitute = { fg = c.charcoal, bg = c.red },

  MatchParen = {
    fg = c.red,
    bg = c.burgundy,
    bold = true,
    underline = true,
  },

  Pmenu = { fg = c.ivory, bg = c.popup },
  PmenuSel = { fg = c.ivory, bg = c.crimson, bold = true },
  PmenuSbar = { bg = c.burgundy },
  PmenuThumb = { bg = c.red },
  PmenuMatch = { fg = c.red, bold = true },
  PmenuMatchSel = { fg = c.ivory, bg = c.crimson, bold = true },
  WildMenu = { fg = c.ivory, bg = c.crimson },

  NonText = { fg = c.slate },
  Whitespace = { fg = c.slate },
  SpecialKey = { fg = c.slate },
  EndOfBuffer = { fg = c.bg },
  Conceal = { fg = c.ivory },

  Directory = { fg = c.red, bold = true },
  Title = { fg = c.red, bold = true },

  ErrorMsg = { fg = c.red, bold = true },
  WarningMsg = { fg = c.red },
  ModeMsg = { fg = c.ivory, bold = true },
  MoreMsg = { fg = c.ivory },
  Question = { fg = c.red },

  QuickFixLine = { bg = c.burgundy },
  SpellBad = { sp = c.red, undercurl = true },
  SpellCap = { sp = c.crimson, undercurl = true },
  SpellLocal = { sp = c.ivory, undercurl = true },
  SpellRare = { sp = c.slate, undercurl = true },

  -- ============================================================
  -- LEGACY VIM SYNTAX
  -- ============================================================

  Comment = { fg = c.slate, italic = true },

  Constant = { fg = c.red },
  String = { fg = c.ivory },
  Character = { fg = c.ivory },
  Number = { fg = c.red },
  Float = { fg = c.red },
  Boolean = { fg = c.red, bold = true },

  Identifier = { fg = c.ivory },
  Function = { fg = c.red, bold = true },

  Statement = { fg = c.crimson, bold = true },
  Conditional = { fg = c.crimson, bold = true },
  Repeat = { fg = c.crimson, bold = true },
  Label = { fg = c.crimson },
  Operator = { fg = c.crimson },
  Keyword = { fg = c.crimson, bold = true },
  Exception = { fg = c.crimson },

  PreProc = { fg = c.ivory },
  Include = { fg = c.crimson },
  Define = { fg = c.crimson },
  Macro = { fg = c.red },
  PreCondit = { fg = c.crimson },

  Type = { fg = c.ivory, bold = true },
  StorageClass = { fg = c.crimson },
  Structure = { fg = c.ivory, bold = true },
  Typedef = { fg = c.ivory, bold = true },

  Special = { fg = c.red },
  SpecialChar = { fg = c.red },
  Tag = { fg = c.red, bold = true },
  Delimiter = { fg = c.ivory },
  SpecialComment = { fg = c.slate, italic = true },
  Debug = { fg = c.red },

  Underlined = { fg = c.red, underline = true },
  Error = { fg = c.red, undercurl = true },
  Todo = { fg = c.charcoal, bg = c.ivory, bold = true },

  -- ============================================================
  -- TREESITTER
  -- ============================================================

  ["@comment"] = { fg = c.slate, italic = true },
  ["@comment.documentation"] = { fg = c.ivory, italic = true },
  ["@comment.todo"] = { fg = c.charcoal, bg = c.ivory, bold = true },
  ["@comment.warning"] = { fg = c.charcoal, bg = c.red, bold = true },
  ["@comment.error"] = { fg = c.ivory, bg = c.crimson, bold = true },
  ["@comment.note"] = { fg = c.charcoal, bg = c.ivory },

  ["@variable"] = { fg = c.ivory },
  ["@variable.builtin"] = { fg = c.red, italic = true },
  ["@variable.parameter"] = { fg = c.red, italic = true },
  ["@variable.member"] = { fg = c.ivory },
  ["@variable.parameter.builtin"] = { fg = c.red, italic = true },

  ["@constant"] = { fg = c.red },
  ["@constant.builtin"] = { fg = c.red, bold = true },
  ["@constant.macro"] = { fg = c.crimson },
  ["@module"] = { fg = c.ivory },
  ["@namespace"] = { fg = c.ivory },
  ["@label"] = { fg = c.crimson },

  ["@string"] = { fg = c.ivory },
  ["@string.documentation"] = { fg = c.ivory, italic = true },
  ["@string.escape"] = { fg = c.red, bold = true },
  ["@string.regexp"] = { fg = c.red },
  ["@string.special"] = { fg = c.red },
  ["@string.interpolation"] = { fg = c.red, bold = true },
  ["@string.special.url"] = { fg = c.ivory, underline = true },
  ["@character"] = { fg = c.ivory },
  ["@number"] = { fg = c.red },
  ["@number.float"] = { fg = c.red },
  ["@boolean"] = { fg = c.red, bold = true },

  ["@type"] = { fg = c.ivory, bold = true },
  ["@type.builtin"] = { fg = c.ivory, bold = true },
  ["@type.definition"] = { fg = c.ivory, bold = true },
  ["@attribute"] = { fg = c.red },
  ["@property"] = { fg = c.ivory },
  ["@function"] = { fg = c.red, bold = true },
  ["@function.builtin"] = { fg = c.crimson, bold = true },
  ["@function.call"] = { fg = c.red, bold = true },
  ["@function.macro"] = { fg = c.crimson },
  ["@function.method"] = { fg = c.red, bold = true },
  ["@function.method.call"] = { fg = c.red, bold = true },
  ["@constructor"] = { fg = c.ivory, bold = true },

  ["@operator"] = { fg = c.crimson },
  ["@keyword"] = { fg = c.crimson, bold = true },
  ["@keyword.function"] = { fg = c.crimson, bold = true },
  ["@keyword.return"] = { fg = c.red, bold = true },
  ["@keyword.operator"] = { fg = c.crimson },
  ["@keyword.import"] = { fg = c.crimson, bold = true },
  ["@keyword.conditional"] = { fg = c.crimson, bold = true },
  ["@keyword.repeat"] = { fg = c.crimson, bold = true },
  ["@keyword.exception"] = { fg = c.red, bold = true },
  ["@keyword.coroutine"] = { fg = c.crimson },
  ["@keyword.directive"] = { fg = c.red },

  ["@punctuation"] = { fg = c.ivory },
  ["@punctuation.delimiter"] = { fg = c.ivory },
  ["@punctuation.bracket"] = { fg = c.red },
  ["@punctuation.special"] = { fg = c.crimson },

  -- ============================================================
  -- MARKUP AND EMBEDDED LANGUAGES
  -- ============================================================

  ["@tag"] = { fg = c.red, bold = true },
  ["@tag.attribute"] = { fg = c.ivory },
  ["@tag.delimiter"] = { fg = c.slate },

  ["@markup.heading"] = { fg = c.red, bold = true },
  ["@markup.strong"] = { fg = c.ivory, bold = true },
  ["@markup.italic"] = { fg = c.ivory, italic = true },
  ["@markup.strikethrough"] = { fg = c.slate, strikethrough = true },
  ["@markup.underline"] = { fg = c.ivory, underline = true },
  ["@markup.link"] = { fg = c.red, underline = true },
  ["@markup.link.url"] = { fg = c.ivory, underline = true },
  ["@markup.raw"] = { fg = c.ivory },
  ["@markup.list"] = { fg = c.red, bold = true },
  ["@markup.quote"] = { fg = c.slate, italic = true },

  ["@diff.plus"] = { fg = c.ivory },
  ["@diff.minus"] = { fg = c.red },
  ["@diff.delta"] = { fg = c.crimson },

  ["@property.css"] = { fg = c.ivory },
  ["@property.json"] = { fg = c.red },

  -- ============================================================
  -- PYTHON TREE-SITTER
  -- ============================================================

  ["@variable.builtin.python"] = { fg = c.red, italic = true },
  ["@function.builtin.python"] = { fg = c.crimson, bold = true },
  ["@type.builtin.python"] = { fg = c.ivory, bold = true },
  ["@attribute.python"] = { fg = c.red },
  ["@string.documentation.python"] = { fg = c.ivory, italic = true },

  -- ============================================================
  -- LSP SEMANTIC TOKENS
  -- ============================================================

  ["@lsp.type.class"] = { fg = c.ivory, bold = true },
  ["@lsp.type.decorator"] = { fg = c.red },
  ["@lsp.type.enum"] = { fg = c.ivory, bold = true },
  ["@lsp.type.enumMember"] = { fg = c.red },
  ["@lsp.type.function"] = { fg = c.red, bold = true },
  ["@lsp.type.interface"] = { fg = c.ivory, bold = true },
  ["@lsp.type.keyword"] = { fg = c.crimson, bold = true },
  ["@lsp.type.macro"] = { fg = c.red },
  ["@lsp.type.method"] = { fg = c.red, bold = true },
  ["@lsp.type.namespace"] = { fg = c.ivory },
  ["@lsp.type.number"] = { fg = c.red },
  ["@lsp.type.operator"] = { fg = c.crimson },
  ["@lsp.type.parameter"] = { fg = c.red, italic = true },
  ["@lsp.type.property"] = { fg = c.ivory },
  ["@lsp.type.string"] = { fg = c.ivory },
  ["@lsp.type.struct"] = { fg = c.ivory, bold = true },
  ["@lsp.type.type"] = { fg = c.ivory, bold = true },
  ["@lsp.type.typeParameter"] = { fg = c.ivory, italic = true },
  ["@lsp.type.variable"] = { fg = c.ivory },

  ["@lsp.typemod.variable.readonly"] = { fg = c.red },
  ["@lsp.typemod.variable.static"] = { fg = c.crimson },
  ["@lsp.typemod.function.defaultLibrary"] = { fg = c.crimson, bold = true },
  ["@lsp.typemod.method.defaultLibrary"] = { fg = c.crimson, bold = true },

  -- ============================================================
  -- DIAGNOSTICS AND REFERENCES
  -- ============================================================

  DiagnosticError = { fg = c.red, bold = true },
  DiagnosticWarn = { fg = c.red },
  DiagnosticInfo = { fg = c.ivory },
  DiagnosticHint = { fg = c.slate },
  DiagnosticOk = { fg = c.ivory },

  DiagnosticUnderlineError = { sp = c.red, undercurl = true },
  DiagnosticUnderlineWarn = { sp = c.crimson, undercurl = true },
  DiagnosticUnderlineInfo = { sp = c.ivory, undercurl = true },
  DiagnosticUnderlineHint = { sp = c.slate, undercurl = true },

  DiagnosticVirtualTextError = { fg = c.red, bg = c.burgundy },
  DiagnosticVirtualTextWarn = { fg = c.ivory, bg = c.burgundy },
  DiagnosticVirtualTextInfo = { fg = c.ivory, bg = c.charcoal },
  DiagnosticVirtualTextHint = { fg = c.slate, bg = c.charcoal },

  LspReferenceText = { bg = c.burgundy },
  LspReferenceRead = { bg = c.burgundy },
  LspReferenceWrite = { bg = c.crimson },

  LspInlayHint = { fg = c.ivory, bg = c.burgundy, italic = true },
  LspCodeLens = { fg = c.slate, italic = true },

  -- ============================================================
  -- DIFF AND GIT
  -- ============================================================

  DiffAdd = { fg = c.ivory, bg = c.burgundy },
  DiffChange = { fg = c.ivory, bg = c.burgundy },
  DiffDelete = { fg = c.red, bg = c.burgundy },
  DiffText = { fg = c.ivory, bg = c.crimson, bold = true },

  Added = { fg = c.ivory },
  Changed = { fg = c.red },
  Removed = { fg = c.crimson },

  GitSignsAdd = { fg = c.ivory },
  GitSignsChange = { fg = c.red },
  GitSignsDelete = { fg = c.crimson },

  -- ============================================================
  -- TELESCOPE, SNACKS AND PICKERS
  -- ============================================================

  TelescopeNormal = { fg = c.ivory, bg = c.bg_float },
  TelescopeBorder = { fg = c.slate, bg = c.bg_float },
  TelescopeSelection = { fg = c.ivory, bg = c.burgundy },
  TelescopeMatching = { fg = c.red, bold = true },

  SnacksPickerMatch = { fg = c.red, bold = true },
  SnacksPickerDir = { fg = c.ivory },
  SnacksIndent = { fg = c.slate },
  SnacksIndentScope = { fg = c.red },

  -- ============================================================
  -- COMPLETION
  -- ============================================================

  CmpItemAbbrMatch = { fg = c.red, bold = true },
  CmpItemAbbrMatchFuzzy = { fg = c.red },

  CmpItemKindFunction = { fg = c.red },
  CmpItemKindMethod = { fg = c.red },
  CmpItemKindVariable = { fg = c.ivory },
  CmpItemKindKeyword = { fg = c.crimson },
  CmpItemKindClass = { fg = c.ivory },
  CmpItemKindProperty = { fg = c.ivory },

  BlinkCmpMenu = { fg = c.ivory, bg = c.popup },
  BlinkCmpMenuSelection = { fg = c.ivory, bg = c.crimson },
  BlinkCmpLabelMatch = { fg = c.red, bold = true },

  -- ============================================================
  -- MISCELLANEOUS PLUGINS
  -- ============================================================

  NeoTreeNormal = { fg = c.ivory, bg = c.bg },
  NeoTreeNormalNC = { fg = c.ivory, bg = c.bg },
  NeoTreeDirectoryName = { fg = c.ivory },
  NeoTreeDirectoryIcon = { fg = c.red },
  NeoTreeRootName = { fg = c.red, bold = true },

  WhichKey = { fg = c.red, bold = true },
  WhichKeyDesc = { fg = c.ivory },
  WhichKeyGroup = { fg = c.crimson },
  WhichKeySeparator = { fg = c.slate },

  IndentBlanklineChar = { fg = c.slate },
  MiniIndentscopeSymbol = { fg = c.red },

  FlashLabel = { fg = c.ivory, bg = c.crimson, bold = true },
  FlashMatch = { fg = c.ivory, bg = c.burgundy },
  FlashCurrent = { fg = c.ivory, bg = c.red, bold = true },

  LazyNormal = { fg = c.ivory, bg = c.bg_float },
  MasonNormal = { fg = c.ivory, bg = c.bg_float },
  NoiceCmdlinePopup = { fg = c.ivory, bg = c.bg_float },
  NotifyBackground = { bg = c.bg_float },

  TreesitterContext = { bg = c.burgundy },
  RenderMarkdownCode = { bg = c.burgundy },
}

for group, opts in pairs(groups) do
  hl(group, opts)
end

-- ==============================================================
-- TERMINAL COLORS
-- ==============================================================

vim.g.terminal_color_0 = c.charcoal
vim.g.terminal_color_1 = c.red
vim.g.terminal_color_2 = c.ivory
vim.g.terminal_color_3 = c.crimson
vim.g.terminal_color_4 = c.ivory
vim.g.terminal_color_5 = c.burgundy
vim.g.terminal_color_6 = c.slate
vim.g.terminal_color_7 = c.ivory

vim.g.terminal_color_8 = c.slate
vim.g.terminal_color_9 = c.red
vim.g.terminal_color_10 = c.ivory
vim.g.terminal_color_11 = c.red
vim.g.terminal_color_12 = c.ivory
vim.g.terminal_color_13 = c.crimson
vim.g.terminal_color_14 = c.slate
vim.g.terminal_color_15 = c.ivory
