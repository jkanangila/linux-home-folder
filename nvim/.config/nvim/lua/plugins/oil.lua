---@type LazySpec
return {
  "stevearc/oil.nvim",
  dependencies = {
    {
      "antosha417/nvim-lsp-file-operations",
      dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-tree.lua" },
      config = true,
    },
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<leader>o"] = { desc = "   Oil File Explorer" },
            ["<leader>oo"] = {
              function()
                local oil = require "oil"
                if vim.bo.filetype == "oil" then
                  oil.close()
                else
                  oil.open()
                end
              end,
              desc = "Toggle Oil (Current Dir)",
            },
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
    view_options = {
      show_hidden = true,
      is_hidden_file = function(name, bufnr)
        return false
      end,
    },
  },
  lazy = false,
}
