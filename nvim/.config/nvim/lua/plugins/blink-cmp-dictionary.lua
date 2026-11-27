local function in_python_comment_or_string()
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then return false end

  while node do
    local type = node:type()
    if type == "comment" or type == "string" or type == "concatenated_string" then return true end
    node = node:parent()
  end

  return false
end

--- Runs on every completion request for the filetypes listed in per_filetype below.
local function dictionary_enabled()
  -- Python: only inside comments and strings.
  if vim.bo.filetype == "python" then return in_python_comment_or_string() end
  return true
end

return {
  "Kaiser-Yang/blink-cmp-dictionary",

  specs = {
    {
      "saghen/blink.cmp",
      optional = true,
      opts = {
        sources = {
          -- per_filetype + inherit_defaults ADDS the dictionary source and keeps whatever
          -- AstroNvim / the community packs put in `sources.default`. The old
          -- `default = function() ... end` replaced that list wholesale.
          per_filetype = {
            markdown = { inherit_defaults = true, "dictionary" },
            text = { inherit_defaults = true, "dictionary" },
            gitcommit = { inherit_defaults = true, "dictionary" },
            python = { inherit_defaults = true, "dictionary" },
          },
          providers = {
            dictionary = {
              name = "Dict",
              module = "blink-cmp-dictionary",
              min_keyword_length = 2,
              enabled = dictionary_enabled,
              opts = {
                dictionary_directories = { vim.fn.stdpath "config" .. "/dictionary" },
              },
            },
          },
        },
      },
    },
  },
}
