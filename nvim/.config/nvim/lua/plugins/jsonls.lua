local cspell_schema = vim.uri_from_fname(vim.fn.stdpath "config" .. "/schemas/cspell.schema.json")

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  opts = {
    config = {
      jsonls = {
        settings = {
          json = {
            schemas = {
              {
                fileMatch = { ".cspell.json", "cspell.json" },
                url = cspell_schema,
              },
            },
          },
        },
      },
    },
  },
}
