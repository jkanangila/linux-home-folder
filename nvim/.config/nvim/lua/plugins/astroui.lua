return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    colorscheme = "astrotheme", -- switch between dark/light with <leader>ub
    highlights = {
      init = {
        -- Set specific syntax tokens or special characters to be italic
        ["@keyword"] = { italic = true },
        ["@operator"] = { italic = true }, -- Special symbols/characters like +, -, *, etc.
        ["@punctuation.delimiter"] = { italic = false }, -- E.g., semicolons, commas
        ["@comment"] = { italic = true },
        ["@variable"] = { italic = false },
        
        -- Traditional Vim syntax groups (for non-Treesitter fallbacks)
        Comment = { italic = true },
        Keyword = { italic = true },
        Operator = { italic = true },
      },
    },
  },
}
