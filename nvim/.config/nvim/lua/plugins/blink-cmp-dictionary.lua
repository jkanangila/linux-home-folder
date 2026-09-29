local function in_python_comment_or_string()
  if vim.bo.filetype ~= "python" then return false end

  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then return false end

  while node do
    local type = node:type()

    -- Python comments
    if type == "comment" then return true end

    -- Python string nodes
    if type == "string" or type == "concatenated_string" then return true end

    node = node:parent()
  end

  return false
end

local function dictionary_enabled()
  -- Always available for prose filetypes.
  if vim.tbl_contains({
    "markdown",
    "text",
    "gitcommit",
  }, vim.bo.filetype) then return true end

  -- For Python, only enable it inside comments/strings.
  if vim.bo.filetype == "python" then return in_python_comment_or_string() end

  return false
end

return {
  "Kaiser-Yang/blink-cmp-dictionary",

  specs = {
    {
      "saghen/blink.cmp",
      optional = true,

      opts = {
        sources = {
          default = function()
            local sources = {
              "lsp",
              "path",
              "snippets",
              "buffer",
            }

            if dictionary_enabled() then table.insert(sources, "dictionary") end

            return sources
          end,

          providers = {
            dictionary = {
              name = "Dict",
              module = "blink-cmp-dictionary",
              min_keyword_length = 2,

              opts = {
                dictionary_directories = {
                  vim.fn.expand "~/.config/nvim/dictionary",
                },
              },
            },
          },
        },
      },
    },
  },
}
