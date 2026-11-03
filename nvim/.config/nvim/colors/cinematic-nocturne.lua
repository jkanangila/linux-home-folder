-- Cinematic Nocturne
-- Rich cinematic palette for AstroVim / Neovim.
-- Designed for strong syntax differentiation, especially Python.

vim.cmd "hi clear"
if vim.fn.exists "syntax_on" == 1 then vim.cmd "syntax reset" end

vim.o.termguicolors = true
vim.o.background = "dark"
vim.g.colors_name = "cinematic-nocturne"

local c = {
  -- ============================================================
  -- ORIGINAL PALETTE
  -- ============================================================

  navy = "#0D1B2A",
  teal = "#006D77",
  purple = "#4B0082",
  charcoal = "#1C1C1C",
  forest = "#1B4332",

  yellow = "#F4B400",
  coral = "#FF6B6B",
  lilac = "#E6D6FF",
  bright_teal = "#00C2CB",
  sage = "#A7C957",

  burgundy = "#800020",
  slate_blue = "#1E3A8A",
  chocolate = "#4E342E",
  midnight = "#0B132B",
  olive = "#3D4D22",

  beige = "#F5E6CA",
  orange = "#FF8C00",
  sand = "#D7B899",
  pink = "#FF2E88",
  mustard = "#E3B505",

  -- ============================================================
  -- UI BACKGROUNDS
  -- ============================================================

  bg = "#0B132B",
  bg_alt = "#0D1B2A",
  bg_hl = "#1C1C1C",
  bg_float = "#0D1B2A",
  bg_popup = "#1C1C1C",
  bg_bar = "#0D1B2A",
  bg_sel = "#4B0082",
  bg_search = "#006D77",
  border = "#1E3A8A",

  -- ============================================================
  -- FOREGROUNDS
  -- ============================================================

  fg = "#F5E6CA",
  fg_soft = "#D7B899",
  fg_dim = "#A7C957",
  comment = "#D7B899",

  -- ============================================================
  -- SEMANTIC SYNTAX COLORS
  -- ============================================================

  keyword = "#FF2E88",
  function_ = "#F4B400",
  type = "#E6D6FF",
  string = "#A7C957",
  parameter = "#FF6B6B",
  property = "#00C2CB",
  builtin = "#FF8C00",
  number = "#E3B505",
  constant = "#F4B400",
  operator = "#FF6B6B",
  namespace = "#006D77",

  -- ============================================================
  -- DIAGNOSTICS AND GIT
  -- ============================================================

  error = "#FF6B6B",
  warn = "#F4B400",
  info = "#00C2CB",
  hint = "#E6D6FF",
  add = "#A7C957",
  change = "#00C2CB",
  delete = "#FF2E88",
}

local function hl(group, opts) vim.api.nvim_set_hl(0, group, opts) end

local groups = {
  -- ============================================================
  -- EDITOR UI
  -- ============================================================

  Normal = { fg = c.fg, bg = c.bg },
  NormalNC = { fg = c.fg, bg = c.bg },
  NormalFloat = { fg = c.fg, bg = c.bg_float },

  FloatBorder = { fg = c.bright_teal, bg = c.bg_float },
  FloatTitle = { fg = c.yellow, bg = c.bg_float, bold = true },
  FloatFooter = { fg = c.sand, bg = c.bg_float },

  Cursor = { fg = c.bg, bg = c.bright_teal },
  CursorIM = { fg = c.bg, bg = c.bright_teal },

  CursorLine = { bg = c.bg_hl },
  CursorColumn = { bg = c.bg_hl },
  ColorColumn = { bg = c.bg_hl },

  CursorLineNr = { fg = c.yellow, bold = true },
  LineNr = { fg = c.slate_blue },

  SignColumn = { bg = c.bg },
  FoldColumn = { fg = c.slate_blue, bg = c.bg },
  Folded = { fg = c.sand, bg = c.bg_alt },

  VertSplit = { fg = c.slate_blue },
  WinSeparator = { fg = c.slate_blue },

  StatusLine = { fg = c.beige, bg = c.bg_bar },
  StatusLineNC = { fg = c.sand, bg = c.bg_alt },

  TabLine = { fg = c.sand, bg = c.bg_alt },
  TabLineSel = { fg = c.beige, bg = c.purple, bold = true },
  TabLineFill = { bg = c.bg },

  WinBar = { fg = c.beige, bg = c.bg },
  WinBarNC = { fg = c.sand, bg = c.bg },

  Visual = { bg = c.purple },
  VisualNOS = { bg = c.purple },

  Search = { fg = c.bg, bg = c.yellow, bold = true },
  IncSearch = { fg = c.bg, bg = c.coral, bold = true },
  CurSearch = { fg = c.bg, bg = c.coral, bold = true },
  Substitute = { fg = c.bg, bg = c.orange },

  MatchParen = {
    fg = c.bright_teal,
    bg = c.bg_hl,
    bold = true,
    underline = true,
  },

  Pmenu = { fg = c.beige, bg = c.bg_popup },
  PmenuSel = { fg = c.bg, bg = c.bright_teal, bold = true },
  PmenuSbar = { bg = c.bg_alt },
  PmenuThumb = { bg = c.slate_blue },
  PmenuMatch = { fg = c.yellow, bold = true },
  PmenuMatchSel = { fg = c.bg, bg = c.bright_teal },
  WildMenu = { fg = c.bg, bg = c.bright_teal },

  NonText = { fg = c.slate_blue },
  Whitespace = { fg = c.slate_blue },
  SpecialKey = { fg = c.teal },
  EndOfBuffer = { fg = c.bg },
  Conceal = { fg = c.sand },

  Directory = { fg = c.bright_teal, bold = true },
  Title = { fg = c.yellow, bold = true },

  ErrorMsg = { fg = c.coral, bold = true },
  WarningMsg = { fg = c.yellow },
  ModeMsg = { fg = c.bright_teal, bold = true },
  MoreMsg = { fg = c.sage },
  Question = { fg = c.bright_teal },

  QuickFixLine = { bg = c.purple },

  SpellBad = { sp = c.coral, undercurl = true },
  SpellCap = { sp = c.yellow, undercurl = true },
  SpellLocal = { sp = c.bright_teal, undercurl = true },
  SpellRare = { sp = c.lilac, undercurl = true },

  -- ============================================================
  -- LEGACY VIM SYNTAX
  -- ============================================================

  Comment = { fg = c.comment, italic = true },

  Constant = { fg = c.constant },
  String = { fg = c.string },
  Character = { fg = c.sage },
  Number = { fg = c.number },
  Float = { fg = c.mustard },
  Boolean = { fg = c.yellow, bold = true },

  Identifier = { fg = c.fg },
  Function = { fg = c.function_, bold = true },

  Statement = { fg = c.keyword, bold = true },
  Conditional = { fg = c.keyword, bold = true },
  Repeat = { fg = c.keyword, bold = true },
  Label = { fg = c.pink },
  Operator = { fg = c.operator },
  Keyword = { fg = c.keyword, bold = true },
  Exception = { fg = c.coral, bold = true },

  PreProc = { fg = c.namespace },
  Include = { fg = c.teal },
  Define = { fg = c.pink },
  Macro = { fg = c.orange },
  PreCondit = { fg = c.teal },

  Type = { fg = c.type, bold = true },
  StorageClass = { fg = c.pink },
  Structure = { fg = c.lilac, bold = true },
  Typedef = { fg = c.lilac },

  Special = { fg = c.orange },
  SpecialChar = { fg = c.orange },
  Tag = { fg = c.coral, bold = true },
  Delimiter = { fg = c.fg_soft },
  SpecialComment = { fg = c.teal, italic = true },
  Debug = { fg = c.coral },

  Underlined = { fg = c.bright_teal, underline = true },
  Error = { fg = c.coral, undercurl = true },
  Todo = { fg = c.bg, bg = c.yellow, bold = true },

  -- ============================================================
  -- TREESITTER CORE
  -- ============================================================

  ["@comment"] = { fg = c.comment, italic = true },
  ["@comment.documentation"] = { fg = c.sand, italic = true },
  ["@comment.todo"] = { fg = c.bg, bg = c.yellow, bold = true },
  ["@comment.warning"] = { fg = c.bg, bg = c.orange, bold = true },
  ["@comment.error"] = { fg = c.bg, bg = c.coral, bold = true },
  ["@comment.note"] = { fg = c.bg, bg = c.bright_teal },

  ["@variable"] = { fg = c.fg },
  ["@variable.builtin"] = { fg = c.orange, italic = true },
  ["@variable.parameter"] = { fg = c.coral, italic = true },
  ["@variable.member"] = { fg = c.bright_teal },
  ["@variable.parameter.builtin"] = { fg = c.orange, italic = true },

  ["@constant"] = { fg = c.yellow },
  ["@constant.builtin"] = { fg = c.yellow, bold = true },
  ["@constant.macro"] = { fg = c.orange },

  ["@module"] = { fg = c.teal },
  ["@namespace"] = { fg = c.teal },
  ["@label"] = { fg = c.pink },

  -- Strings
  ["@string"] = { fg = c.sage },
  ["@string.documentation"] = { fg = c.sage, italic = true },
  ["@string.escape"] = { fg = c.orange, bold = true },
  ["@string.regexp"] = { fg = c.coral },
  ["@string.special"] = { fg = c.orange },
  ["@string.interpolation"] = { fg = c.yellow, bold = true },
  ["@string.special.url"] = { fg = c.bright_teal, underline = true },
  ["@character"] = { fg = c.sage },

  -- Numbers
  ["@number"] = { fg = c.mustard },
  ["@number.float"] = { fg = c.mustard },
  ["@boolean"] = { fg = c.yellow, bold = true },

  -- Types and functions
  ["@type"] = { fg = c.lilac, bold = true },
  ["@type.builtin"] = { fg = c.lilac },
  ["@type.definition"] = { fg = c.lilac, bold = true },

  ["@attribute"] = { fg = c.bright_teal },
  ["@property"] = { fg = c.bright_teal },

  ["@function"] = { fg = c.yellow, bold = true },
  ["@function.builtin"] = { fg = c.orange },
  ["@function.call"] = { fg = c.yellow, bold = true },
  ["@function.macro"] = { fg = c.teal },
  ["@function.method"] = { fg = c.yellow, bold = true },
  ["@function.method.call"] = { fg = c.yellow, bold = true },

  ["@constructor"] = { fg = c.lilac, bold = true },

  -- Keywords
  ["@operator"] = { fg = c.coral },
  ["@keyword"] = { fg = c.pink, bold = true },
  ["@keyword.function"] = { fg = c.pink, bold = true },
  ["@keyword.return"] = { fg = c.hot_pink or c.pink, bold = true },
  ["@keyword.operator"] = { fg = c.pink },
  ["@keyword.import"] = { fg = c.pink, bold = true },
  ["@keyword.conditional"] = { fg = c.pink, bold = true },
  ["@keyword.repeat"] = { fg = c.pink, bold = true },
  ["@keyword.exception"] = { fg = c.coral, bold = true },
  ["@keyword.coroutine"] = { fg = c.pink },
  ["@keyword.directive"] = { fg = c.teal },

  -- Punctuation
  ["@punctuation"] = { fg = c.fg_soft },
  ["@punctuation.delimiter"] = { fg = c.fg_soft },
  ["@punctuation.bracket"] = { fg = c.lilac },
  ["@punctuation.special"] = { fg = c.orange },

  -- ============================================================
  -- MARKUP AND EMBEDDED LANGUAGES
  -- ============================================================

  ["@tag"] = { fg = c.coral, bold = true },
  ["@tag.attribute"] = { fg = c.bright_teal },
  ["@tag.delimiter"] = { fg = c.slate_blue },

  ["@markup.heading"] = { fg = c.yellow, bold = true },
  ["@markup.strong"] = { fg = c.beige, bold = true },
  ["@markup.italic"] = { fg = c.lilac, italic = true },
  ["@markup.strikethrough"] = { fg = c.sand, strikethrough = true },
  ["@markup.underline"] = { underline = true },
  ["@markup.link"] = { fg = c.bright_teal, underline = true },
  ["@markup.link.url"] = { fg = c.teal, underline = true },
  ["@markup.raw"] = { fg = c.sage },
  ["@markup.list"] = { fg = c.orange },
  ["@markup.quote"] = { fg = c.sand, italic = true },

  ["@diff.plus"] = { fg = c.sage },
  ["@diff.minus"] = { fg = c.coral },
  ["@diff.delta"] = { fg = c.bright_teal },

  ["@property.css"] = { fg = c.bright_teal },
  ["@property.json"] = { fg = c.coral },

  -- ============================================================
  -- PYTHON TREE-SITTER
  -- ============================================================

  ["@variable.builtin.python"] = { fg = c.orange, italic = true },
  ["@function.builtin.python"] = { fg = c.orange, bold = true },
  ["@type.builtin.python"] = { fg = c.lilac, bold = true },
  ["@attribute.python"] = { fg = c.bright_teal },
  ["@string.documentation.python"] = { fg = c.sage, italic = true },

  -- ============================================================
  -- LSP SEMANTIC TOKENS
  -- ============================================================

  ["@lsp.type.class"] = { fg = c.lilac, bold = true },
  ["@lsp.type.decorator"] = { fg = c.bright_teal },
  ["@lsp.type.enum"] = { fg = c.lilac, bold = true },
  ["@lsp.type.enumMember"] = { fg = c.yellow },
  ["@lsp.type.function"] = { fg = c.yellow, bold = true },
  ["@lsp.type.interface"] = { fg = c.lilac, bold = true },
  ["@lsp.type.keyword"] = { fg = c.pink, bold = true },
  ["@lsp.type.macro"] = { fg = c.teal },
  ["@lsp.type.method"] = { fg = c.yellow, bold = true },
  ["@lsp.type.namespace"] = { fg = c.teal },
  ["@lsp.type.number"] = { fg = c.mustard },
  ["@lsp.type.operator"] = { fg = c.coral },
  ["@lsp.type.parameter"] = { fg = c.coral, italic = true },
  ["@lsp.type.property"] = { fg = c.bright_teal },
  ["@lsp.type.string"] = { fg = c.sage },
  ["@lsp.type.struct"] = { fg = c.lilac, bold = true },
  ["@lsp.type.type"] = { fg = c.lilac, bold = true },
  ["@lsp.type.typeParameter"] = { fg = c.lilac, italic = true },
  ["@lsp.type.variable"] = { fg = c.fg },

  ["@lsp.typemod.variable.readonly"] = { fg = c.yellow },
  ["@lsp.typemod.variable.static"] = { fg = c.purple },
  ["@lsp.typemod.function.defaultLibrary"] = { fg = c.orange },
  ["@lsp.typemod.method.defaultLibrary"] = { fg = c.orange },

  -- ============================================================
  -- DIAGNOSTICS AND REFERENCES
  -- ============================================================

  DiagnosticError = { fg = c.coral, bold = true },
  DiagnosticWarn = { fg = c.yellow },
  DiagnosticInfo = { fg = c.bright_teal },
  DiagnosticHint = { fg = c.lilac },
  DiagnosticOk = { fg = c.sage },

  DiagnosticUnderlineError = { sp = c.coral, undercurl = true },
  DiagnosticUnderlineWarn = { sp = c.yellow, undercurl = true },
  DiagnosticUnderlineInfo = { sp = c.bright_teal, undercurl = true },
  DiagnosticUnderlineHint = { sp = c.lilac, undercurl = true },

  DiagnosticVirtualTextError = { fg = c.coral, bg = c.burgundy },
  DiagnosticVirtualTextWarn = { fg = c.yellow, bg = c.chocolate },
  DiagnosticVirtualTextInfo = { fg = c.bright_teal, bg = c.navy },
  DiagnosticVirtualTextHint = { fg = c.lilac, bg = c.purple },

  LspReferenceText = { bg = c.slate_blue },
  LspReferenceRead = { bg = c.slate_blue },
  LspReferenceWrite = { bg = c.purple },

  LspInlayHint = { fg = c.sand, bg = c.bg_alt, italic = true },
  LspCodeLens = { fg = c.sand, italic = true },

  -- ============================================================
  -- DIFF AND GIT
  -- ============================================================

  DiffAdd = { bg = c.forest },
  DiffChange = { bg = c.navy },
  DiffDelete = { bg = c.burgundy },
  DiffText = { bg = c.slate_blue },

  Added = { fg = c.sage },
  Changed = { fg = c.bright_teal },
  Removed = { fg = c.coral },

  GitSignsAdd = { fg = c.sage },
  GitSignsChange = { fg = c.bright_teal },
  GitSignsDelete = { fg = c.coral },

  -- ============================================================
  -- TELESCOPE, SNACKS AND PICKERS
  -- ============================================================

  TelescopeNormal = { fg = c.beige, bg = c.bg_float },
  TelescopeBorder = { fg = c.slate_blue, bg = c.bg_float },
  TelescopeSelection = { fg = c.beige, bg = c.purple },
  TelescopeMatching = { fg = c.yellow, bold = true },

  SnacksPickerMatch = { fg = c.yellow, bold = true },
  SnacksPickerDir = { fg = c.bright_teal },
  SnacksIndent = { fg = c.slate_blue },
  SnacksIndentScope = { fg = c.purple },

  -- ============================================================
  -- COMPLETION
  -- ============================================================

  CmpItemAbbrMatch = { fg = c.yellow, bold = true },
  CmpItemAbbrMatchFuzzy = { fg = c.yellow },

  CmpItemKindFunction = { fg = c.yellow },
  CmpItemKindMethod = { fg = c.yellow },
  CmpItemKindVariable = { fg = c.fg },
  CmpItemKindKeyword = { fg = c.pink },
  CmpItemKindClass = { fg = c.lilac },
  CmpItemKindProperty = { fg = c.bright_teal },

  BlinkCmpMenu = { fg = c.beige, bg = c.bg_popup },
  BlinkCmpMenuSelection = { fg = c.bg, bg = c.bright_teal },
  BlinkCmpLabelMatch = { fg = c.yellow, bold = true },

  -- ============================================================
  -- MISCELLANEOUS PLUGINS
  -- ============================================================

  NeoTreeNormal = { fg = c.beige, bg = c.bg },
  NeoTreeNormalNC = { fg = c.beige, bg = c.bg },
  NeoTreeDirectoryName = { fg = c.bright_teal },
  NeoTreeDirectoryIcon = { fg = c.teal },
  NeoTreeRootName = { fg = c.yellow, bold = true },

  WhichKey = { fg = c.yellow, bold = true },
  WhichKeyDesc = { fg = c.beige },
  WhichKeyGroup = { fg = c.pink },
  WhichKeySeparator = { fg = c.sand },

  IndentBlanklineChar = { fg = c.slate_blue },
  MiniIndentscopeSymbol = { fg = c.bright_teal },

  FlashLabel = { fg = c.bg, bg = c.orange, bold = true },
  FlashMatch = { fg = c.beige, bg = c.purple },
  FlashCurrent = { fg = c.bg, bg = c.yellow, bold = true },

  LazyNormal = { fg = c.beige, bg = c.bg_float },
  MasonNormal = { fg = c.beige, bg = c.bg_float },
  NoiceCmdlinePopup = { fg = c.beige, bg = c.bg_float },
  NotifyBackground = { bg = c.bg_float },

  TreesitterContext = { bg = c.navy },
  RenderMarkdownCode = { bg = c.bg_alt },
}

-- Apply highlight groups
for group, opts in pairs(groups) do
  hl(group, opts)
end

-- ============================================================
-- TERMINAL COLORS (16 ANSI)
-- ============================================================

vim.g.terminal_color_0 = c.midnight
vim.g.terminal_color_1 = c.coral
vim.g.terminal_color_2 = c.sage
vim.g.terminal_color_3 = c.yellow
vim.g.terminal_color_4 = c.slate_blue
vim.g.terminal_color_5 = c.purple
vim.g.terminal_color_6 = c.bright_teal
vim.g.terminal_color_7 = c.beige

vim.g.terminal_color_8 = c.slate_blue
vim.g.terminal_color_9 = c.pink
vim.g.terminal_color_10 = c.forest
vim.g.terminal_color_11 = c.mustard
vim.g.terminal_color_12 = c.bright_teal
vim.g.terminal_color_13 = c.lilac
vim.g.terminal_color_14 = c.teal
vim.g.terminal_color_15 = "#FFFFFF"
