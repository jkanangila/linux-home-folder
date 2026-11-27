-- lua/polish.lua
-- Runs after lazy.setup(). Theme hooks must never be able to break startup, hence pcall.

-- Global highlight preferences: italic keywords and comments, everything else upright.
local italic_groups = {
  "Keyword",
  "@keyword",
  "@keyword.coroutine",
  "@keyword.function",
  "@keyword.exception",
  "@keyword.conditional",
  "@keyword.repeat",
  "@keyword.import",
  "@keyword.return",
  "@keyword.operator",
  "Comment",
  "@comment",
  "@comment.documentation",
}

local function apply_italics()
  for _, name in ipairs(italic_groups) do
    if vim.fn.hlexists(name) == 1 then
      local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
      hl.italic = true
      vim.api.nvim_set_hl(0, name, hl)
    end
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("custom_italics", { clear = true }),
  callback = apply_italics,
})

-- Apply to whichever colorscheme is currently active.
apply_italics()
