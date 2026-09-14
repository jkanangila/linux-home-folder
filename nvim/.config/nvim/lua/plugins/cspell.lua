return {
  {
    "nvimtools/none-ls.nvim",
    event = "BufReadPost",
    dependencies = {
      "davidmh/cspell.nvim",
    },
    opts = function(_, opts)
      local cspell = require "cspell"

      opts.sources = opts.sources or {}

      table.insert(
        opts.sources,
        cspell.diagnostics.with {
          filetypes = {
            "python",
            "lua",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "json",
            "yaml",
            "toml",
            "markdown",
            "text",
            "gitcommit",
          },
        }
      )

      table.insert(
        opts.sources,
        cspell.code_actions.with {
          filetypes = {
            "python",
            "lua",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "json",
            "yaml",
            "toml",
            "markdown",
            "text",
            "gitcommit",
          },
        }
      )
    end,
  },
}
