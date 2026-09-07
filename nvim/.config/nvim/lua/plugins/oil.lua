---@type LazySpec
return {
  -- AstroNvim normally uses Neo-tree as its file explorer.
  -- Disable it because Oil.nvim is being used instead.
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },

  {
    "stevearc/oil.nvim",

    -- Oil needs to be available immediately so it can handle directory
    -- buffers, including when Neovim is started with `nvim .`.
    lazy = false,

    dependencies = {
      -- Adds LSP-aware file operations to Oil.
      --
      -- This allows operations such as rename/delete/move to notify
      -- language servers so references and imports can be updated.
      {
        "antosha417/nvim-lsp-file-operations",
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
        config = true,
      },

      -- Adds Git status information to Oil.
      --
      -- Files can be highlighted according to their Git state
      -- (modified, untracked, ignored, etc.).
      {
        "malewicz1337/oil-git.nvim",
        dependencies = {
          "stevearc/oil.nvim",
        },
        opts = {
          -- Show Git status using file highlights.
          show_file_highlights = true,

          -- Don't apply Git highlighting to directories.
          show_directory_symbols = false,
          show_file_symbols = false,

          show_branch = true, -- Show current Git branch in oil buffers

          -- Include files ignored by Git in Oil's Git information.
          show_ignored_files = true,
        },
      },

      -- AstroNvim's core plugin is used here to register the keymaps
      -- through AstroNvim's mapping system.
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              -- Create a <leader>o which-key group for Oil commands.
              ["<leader>o"] = {
                desc = "   Oil File Explorer",
              },

              -- Toggle Oil in the current working directory.
              --
              -- If Oil is already open, close it.
              -- Otherwise, open Oil in the current directory.
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

              -- Toggle Oil in the current working directory.
              --
              -- NOTE: `oil.open(".")` opens Neovim's current working
              -- directory. It is not necessarily the Git/project root.
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
      -- Make Oil the default file explorer.
      --
      -- This allows Oil to handle directory buffers automatically,
      -- e.g.:
      --
      --     nvim .
      --
      -- will open the directory in Oil instead of the default
      -- directory browser.
      default_file_explorer = true,

      -- Configure LSP-aware file operations.
      lsp_file_methods = {
        -- Allow up to two minutes for an LSP file operation.
        timeout_ms = 120000,

        -- Automatically save changes made as a result of file operations.
        autosave_changes = true,
      },

      view_options = {
        -- Display hidden files such as `.gitignore`, `.env`, etc.
        show_hidden = true,

        -- Treat every file as visible.
        --
        -- Returning false means Oil will not classify a file as hidden
        -- based on this callback. Combined with `show_hidden = true`,
        -- this makes Oil show files that would normally be hidden.
        is_hidden_file = function(_, _) return false end,
      },
    },
  },
}
