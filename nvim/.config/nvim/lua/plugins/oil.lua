---@type LazySpec

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },

  {
    "stevearc/oil.nvim",

    lazy = false,

    dependencies = {
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
    },

    opts = {
      default_file_explorer = true,

      lsp_file_methods = {
        enabled = false,
      },

      view_options = {
        show_hidden = true,

        is_hidden_file = function(_, _) return false end,
      },
    },
  },

  {
    "AstroNvim/astrocore",

    opts = function(_, opts)
      local oil = require "oil"
      local oil_cspell = require "oil-cspell"

      opts.mappings = opts.mappings or {}
      opts.mappings.n = opts.mappings.n or {}

      local mappings = opts.mappings.n

      mappings["<leader>o"] = {
        desc = "Oil File Explorer",
      }

      mappings["<leader>oo"] = {
        function()
          if vim.bo.filetype == "oil" then
            oil.close()
          else
            oil.open()
          end
        end,

        desc = "Toggle Oil (Current Dir)",
      }

      mappings["<leader>or"] = {
        function()
          if vim.bo.filetype == "oil" then
            oil.close()
          else
            oil.open "."
          end
        end,

        desc = "Toggle Oil (Project Root)",
      }

      ------------------------------------------------------------------
      -- CSpell
      ------------------------------------------------------------------

      mappings["<leader>cs"] = {
        function()
          if vim.bo.filetype ~= "oil" then
            vim.notify("CSpell filename checking is only available in Oil", vim.log.levels.WARN)

            return
          end

          oil_cspell.check_current()
        end,

        desc = "CSpell: Check Filename",
      }

      mappings["<leader>ca"] = {
        function()
          if vim.bo.filetype ~= "oil" then return end

          oil_cspell.code_actions()
        end,

        desc = "CSpell: Suggestions",
      }

      mappings["<leader>cS"] = {
        function()
          if vim.bo.filetype ~= "oil" then return end

          oil_cspell.clear()
        end,

        desc = "CSpell: Clear Diagnostic",
      }
    end,
  },
}
