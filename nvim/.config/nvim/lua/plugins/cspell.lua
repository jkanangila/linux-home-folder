local filetypes = {
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
}

return {
  {
    "nvimtools/none-ls.nvim",
    event = "BufReadPost",
    dependencies = { "davidmh/cspell.nvim" },
    opts = function(_, opts)
      local cspell = require "cspell"

      opts.sources = opts.sources or {}

      table.insert(
        opts.sources,
        cspell.diagnostics.with {
          filetypes = filetypes,
          -- Spelling is advice, not an error: keep it from drowning real ruff/basedpyright errors.
          diagnostics_postprocess = function(diagnostic) diagnostic.severity = vim.diagnostic.severity.HINT end,
        }
      )
      table.insert(opts.sources, cspell.code_actions.with { filetypes = filetypes })
    end,
  },
}
