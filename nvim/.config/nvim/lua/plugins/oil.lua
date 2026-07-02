return {
  "stevearc/oil.nvim",
  dependencies = {
    {
      "antosha417/nvim-lsp-file-operations",
      config = true,
    },
    {
      "AstroNvim/astrocore",
      ---@type AstroCoreOpts
      opts = {
        mappings = {
          n = {
            ["<leader>o"] = { desc = "󰏇 Oil File Explorer" },

            ---@doc Toggle Oil in the directory of the current active buffer
            ["<leader>oo"] = {
              function()
                local oil = require "oil"
                -- Check if the current buffer is an oil buffer
                if vim.bo.filetype == "oil" then
                  oil.close()
                else
                  oil.open()
                end
              end,
              desc = "Toggle Oil (Current Dir)",
            },

            ---@doc Toggle Oil starting from the project root directory
            ["<leader>or"] = {
              function()
                local oil = require "oil"
                if vim.bo.filetype == "oil" then
                  oil.close()
                else
                  oil.open "."
                end
              end,
              desc = "Toggle Oil (Project Root)",
            },
          },
        },
      },
    },
  },
  opts = {
    lsp_file_methods = {
      timeout_ms = 120000,
      autosave_changes = true,
    },
  },
  lazy = false,
}
