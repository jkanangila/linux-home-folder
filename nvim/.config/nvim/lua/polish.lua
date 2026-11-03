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
    -- Do not create missing highlight groups.
    if vim.fn.hlexists(name) == 1 then
      local hl = vim.api.nvim_get_hl(0, {
        name = name,
        link = false,
      })

      hl.italic = true

      vim.api.nvim_set_hl(0, name, hl)
    end
  end
end

local group = vim.api.nvim_create_augroup("custom_italics", {
  clear = true,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = apply_italics,
})

-- Apply after the current colorscheme has loaded.
apply_italics()
