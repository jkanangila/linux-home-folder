-- lua/plugins/neon-highlights.lua
-- Neon syntax colors with a transparent editor body.
-- Keeps distinct backgrounds for the statusline, tabs, bufferline,
-- breadcrumbs, and floating windows.

return {
  {
    "AstroNvim/astrocore",
    opts = function()
      local group = vim.api.nvim_create_augroup("NeonSyntaxOverrides", { clear = true })

      local c = {
        bg = "#10101B",
        bg_float = "#171729",
        fg = "#EAE8FF",
        muted = "#777A9E",
        cyan = "#00E5FF",
        blue = "#54A6FF",
        pink = "#FF38D1",
        purple = "#BD93F9",
        green = "#50FA7B",
        lime = "#B6FF00",
        yellow = "#FFE66D",
        orange = "#FF9E3D",
        red = "#FF5370",
        teal = "#00F5D4",
        border = "#414164",
        selection = "#353052",
        cursorline = "#1A1A2E",
      }

      local function apply()
        if vim.g.colors_name ~= "caelestia" then return end

        local set = vim.api.nvim_set_hl

        local highlights = {
          -- Main editing area: transparent
          Normal = { fg = c.fg, bg = "NONE" },
          NormalNC = { fg = c.fg, bg = "NONE" },
          SignColumn = { bg = "NONE" },
          FoldColumn = { bg = "NONE" },
          LineNr = { fg = c.muted, bg = "NONE" },
          CursorLineNr = {
            fg = c.cyan,
            bg = "NONE",
            bold = true,
          },
          CursorLine = { bg = c.cursorline },
          ColorColumn = { bg = c.cursorline },
          EndOfBuffer = { fg = c.border, bg = "NONE" },

          -- Editor selections and search
          Visual = { bg = c.selection },
          Search = {
            fg = c.bg,
            bg = c.yellow,
            bold = true,
          },
          IncSearch = {
            fg = c.bg,
            bg = c.orange,
            bold = true,
          },
          CurSearch = {
            fg = c.bg,
            bg = c.pink,
            bold = true,
          },
          MatchParen = {
            fg = c.yellow,
            bg = "NONE",
            bold = true,
            underline = true,
          },

          -- Window borders and separators
          WinSeparator = { fg = c.border, bg = "NONE" },
          VertSplit = { fg = c.border, bg = "NONE" },

          -- Floating windows and completion menus
          NormalFloat = { fg = c.fg, bg = c.bg_float },
          FloatBorder = { fg = c.cyan, bg = c.bg_float },
          FloatTitle = {
            fg = c.pink,
            bg = c.bg_float,
            bold = true,
          },
          Pmenu = { fg = c.fg, bg = c.bg_float },
          PmenuSel = {
            fg = c.bg,
            bg = c.cyan,
            bold = true,
          },
          PmenuSbar = { bg = c.bg_float },
          PmenuThumb = { bg = c.purple },

          -- Statusline
          StatusLine = { fg = c.fg, bg = c.bg_float },
          StatusLineNC = { fg = c.muted, bg = c.bg_float },

          -- Built-in tabline
          TabLine = { fg = c.muted, bg = c.bg_float },
          TabLineFill = { bg = c.bg_float },
          TabLineSel = {
            fg = c.cyan,
            bg = c.bg,
            bold = true,
          },

          -- Bufferline (when these groups are used)
          BufferLineFill = { bg = c.bg_float },
          BufferLineBackground = {
            fg = c.muted,
            bg = c.bg_float,
          },
          BufferLineBufferSelected = {
            fg = c.cyan,
            bg = c.bg,
            bold = true,
          },
          BufferLineBufferVisible = {
            fg = c.fg,
            bg = c.bg_float,
          },
          BufferLineSeparator = {
            fg = c.border,
            bg = c.bg_float,
          },
          BufferLineSeparatorSelected = {
            fg = c.border,
            bg = c.bg,
          },
          BufferLineIndicatorSelected = {
            fg = c.pink,
            bg = c.bg,
          },

          -- Breadcrumbs (common Navic / Winbar groups)
          WinBar = { fg = c.fg, bg = c.bg_float },
          WinBarNC = { fg = c.muted, bg = c.bg_float },
          NavicText = { fg = c.fg, bg = c.bg_float },
          NavicSeparator = { fg = c.cyan, bg = c.bg_float },
          NavicIconsFile = { fg = c.cyan, bg = c.bg_float },
          NavicIconsModule = { fg = c.blue, bg = c.bg_float },
          NavicIconsNamespace = { fg = c.blue, bg = c.bg_float },
          NavicIconsClass = { fg = c.yellow, bg = c.bg_float },
          NavicIconsMethod = { fg = c.cyan, bg = c.bg_float },
          NavicIconsFunction = { fg = c.cyan, bg = c.bg_float },
          NavicIconsProperty = { fg = c.blue, bg = c.bg_float },

          -- Comments
          Comment = { fg = c.muted, italic = true },
          ["@comment"] = { link = "Comment" },
          ["@comment.documentation"] = {
            fg = c.purple,
            italic = true,
          },

          -- Strings
          String = { fg = c.green },
          Character = { fg = c.lime },
          ["@string"] = { link = "String" },
          ["@string.escape"] = {
            fg = c.orange,
            bold = true,
          },
          ["@string.special"] = {
            fg = c.yellow,
            bold = true,
          },
          ["@character"] = { link = "Character" },

          -- Numbers and constants
          Number = { fg = c.orange, bold = true },
          Float = { fg = c.orange, bold = true },
          Boolean = { fg = c.pink, bold = true },
          Constant = { fg = c.yellow },
          ["@number"] = { link = "Number" },
          ["@float"] = { link = "Float" },
          ["@boolean"] = { link = "Boolean" },
          ["@constant"] = { link = "Constant" },
          ["@constant.builtin"] = {
            fg = c.pink,
            bold = true,
          },
          ["@constant.macro"] = { fg = c.orange },

          -- Functions and methods
          Function = { fg = c.cyan, bold = true },
          ["@function"] = { link = "Function" },
          ["@function.call"] = { fg = c.cyan },
          ["@function.method"] = {
            fg = c.cyan,
            bold = true,
          },
          ["@function.method.call"] = { fg = c.cyan },
          ["@function.builtin"] = {
            fg = c.blue,
            bold = true,
          },
          ["@function.macro"] = { fg = c.purple },
          ["@method"] = { fg = c.cyan },
          ["@constructor"] = {
            fg = c.yellow,
            bold = true,
          },

          -- Keywords and control flow
          Statement = { fg = c.pink, bold = true },
          Keyword = { fg = c.pink, bold = true },
          Conditional = { fg = c.pink, bold = true },
          Repeat = { fg = c.pink, bold = true },
          Exception = { fg = c.red, bold = true },
          Label = { fg = c.purple },
          ["@keyword"] = { link = "Keyword" },
          ["@keyword.function"] = {
            fg = c.purple,
            bold = true,
          },
          ["@keyword.operator"] = {
            fg = c.teal,
            bold = true,
          },
          ["@keyword.return"] = {
            fg = c.red,
            bold = true,
          },
          ["@conditional"] = { link = "Conditional" },
          ["@repeat"] = { link = "Repeat" },
          ["@exception"] = { link = "Exception" },

          -- Operators and punctuation
          Operator = { fg = c.teal },
          ["@operator"] = { link = "Operator" },
          Delimiter = { fg = c.purple },
          ["@punctuation.bracket"] = { fg = c.blue },
          ["@punctuation.delimiter"] = { fg = c.purple },
          ["@punctuation.special"] = {
            fg = c.pink,
            bold = true,
          },

          -- Types, classes, and modules
          Type = { fg = c.yellow },
          StorageClass = { fg = c.purple, bold = true },
          Structure = { fg = c.yellow },
          Typedef = { fg = c.yellow },
          PreProc = { fg = c.purple },
          Include = { fg = c.pink },
          Define = { fg = c.purple },
          Macro = { fg = c.purple },
          ["@type"] = { link = "Type" },
          ["@type.builtin"] = {
            fg = c.blue,
            bold = true,
          },
          ["@type.definition"] = {
            fg = c.yellow,
            bold = true,
          },
          ["@type.qualifier"] = { fg = c.purple },
          ["@attribute"] = { fg = c.purple },
          ["@attribute.builtin"] = { fg = c.pink },
          ["@module"] = { fg = c.blue },
          ["@namespace"] = { fg = c.blue },

          -- Variables, parameters, and properties
          Identifier = { fg = c.fg },
          ["@variable"] = { fg = c.fg },
          ["@variable.builtin"] = {
            fg = c.pink,
            bold = true,
          },
          ["@variable.parameter"] = {
            fg = c.purple,
            italic = true,
          },
          ["@variable.parameter.builtin"] = {
            fg = c.pink,
            italic = true,
          },
          ["@property"] = { fg = c.blue },
          ["@field"] = { fg = c.blue },

          -- Markup / HTML / JSX / TSX
          ["@tag"] = { fg = c.pink, bold = true },
          ["@tag.builtin"] = { fg = c.pink, bold = true },
          ["@tag.attribute"] = { fg = c.cyan },
          ["@tag.delimiter"] = { fg = c.purple },
          ["@markup"] = { fg = c.fg },
          ["@markup.heading"] = {
            fg = c.cyan,
            bold = true,
          },
          ["@markup.strong"] = { bold = true },
          ["@markup.italic"] = { italic = true },
          ["@markup.link"] = {
            fg = c.cyan,
            underline = true,
          },
          ["@markup.raw"] = { fg = c.green },
          ["@markup.list"] = { fg = c.pink },

          -- Diagnostics
          DiagnosticError = { fg = c.red },
          DiagnosticWarn = { fg = c.orange },
          DiagnosticInfo = { fg = c.cyan },
          DiagnosticHint = { fg = c.purple },
          DiagnosticOk = { fg = c.green },

          -- Diff
          Added = { fg = c.green },
          Changed = { fg = c.cyan },
          Removed = { fg = c.red },

          -- TODO / FIXME markers
          Todo = {
            fg = c.bg,
            bg = c.yellow,
            bold = true,
          },
          ["@text.todo"] = { link = "Todo" },
        }

        for name, spec in pairs(highlights) do
          set(0, name, spec)
        end
      end

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        pattern = "*",
        callback = function() vim.schedule(apply) end,
      })

      vim.schedule(apply)
    end,
  },
}
