return {
  "MagicDuck/grug-far.nvim",
  ---@type GrugFarOptions
  opts = {
    -- Overriding the buffer-local keymaps active inside the GrugFar UI buffer
    keymaps = {
      -- Note: Mapping to `<leader>` within the buffer works, but be aware it overrides
      -- global leader mappings while your cursor is active inside the GrugFar window.

      ---@doc Execute the global search and replace operation across all matches
      replace = { n = "<leader>r" },

      ---@doc Open the built-in GrugFar help menu/documentation popup
      help = { n = "g?" },

      ---@doc Open the file and jump to the exact line under your cursor
      gotoLocation = { n = "<CR>" },

      ---@doc Preview the next file/match location without leaving the search buffer
      openNextLocation = { n = "<C-j>" },

      ---@doc Preview the previous file/match location without leaving the search buffer
      openPrevLocation = { n = "<C-k>" },

      ---@doc Dump all current search results directly into the Neovim Quickfix list
      qflist = { n = "<leader>q" },

      ---@doc Sync direct text edits made in the results area back into their actual source files
      syncLocations = { n = "<leader>s" },

      ---@doc Abort/kill the currently running search process
      abort = { n = "<leader>x" },
    },
  },
  dependencies = {
    {
      "AstroNvim/astrocore",
      ---@type AstroCoreOpts
      opts = {
        mappings = {
          -- Normal Mode Global Mappings
          n = {
            -- Define the description for the prefix group
            ["<leader>s"] = { desc = "󰛔 Search & Replace" },

            ---@doc Open a new GrugFar buffer to search across the entire project workspace
            ["<leader>sr"] = { "<cmd>GrugFar<cr>", desc = "Search and Replace Workspace" },

            ---@doc Open GrugFar with the search field prefilled with the word under the cursor
            ["<leader>sw"] = {
              function() require("grug-far").open { prefills = { search = vim.fn.expand "<cword>" } } end,
              desc = "Search Word Under Cursor",
            },

            ---@doc Open GrugFar restricted only to the file path of your current active buffer
            ["<leader>sf"] = {
              function() require("grug-far").open { prefills = { paths = vim.fn.expand "%" } } end,
              desc = "Search Current File Only",
            },
          },

          -- Visual Mode Global Mappings
          v = {
            ["<leader>s"] = { desc = "󰛔 Search & Replace" },

            ---@doc Open GrugFar prefilled with whatever text you currently have highlighted
            ["<leader>sr"] = {
              function() require("grug-far").with_visual_selection() end,
              desc = "Search Selection Workspace",
            },
          },
        },
      },
    },
  },
}
