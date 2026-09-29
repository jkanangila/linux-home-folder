return {
  "AstroNvim/astrolsp",
  opts = {
    config = {
      jsonls = {
        settings = {
          json = {
            schemas = {
              {
                fileMatch = {
                  ".cspell.json",
                  "cspell.json",
                },
                url = "file://" .. vim.fn.expand "~/.config/nvim/schemas/cspell.schema.json",
              },
            },
          },
        },
      },
    },
  },
}
