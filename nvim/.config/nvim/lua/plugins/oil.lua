---@type LazySpec
return {
  -- Disable Neo-tree in favor of Oil
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },

  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
      -- Git status indicators for Oil
      {
        "malewicz1337/oil-git.nvim",
        opts = {
          show_file_highlights = true,
          show_directory_symbols = false,
          show_file_symbols = false,
          show_branch = true,
          show_ignored_files = true,
        },
      },

      -- AstroNvim keymap integration
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<leader>o"] = { desc = "Oil File Explorer" },
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
      default_file_explorer = true,

      -- Disable Oil's internal LSP file operations so Pymple can handle
      -- Python import updates cleanly without race conditions or extra prompts.
      lsp_file_methods = {
        enabled = false,
      },

      view_options = {
        show_hidden = true,
        is_hidden_file = function(_, _) return false end,
      },
    },
  },
}
