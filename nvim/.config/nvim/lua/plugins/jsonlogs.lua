return {
  "ll931217/jsonlogs.nvim",
  ft = "jsonl",

  -- Register the Which-Key group independently of plugin setup.
  init = function()
    require("which-key").add {
      { "<leader>J", group = "JSON Logs" },
    }
  end,

  opts = {
    prefix = "<leader>J",
    auto_open = true,

    -- Keep the plugin's native shortcuts at their defaults.
  },

  keys = {
    -- ========================================================================
    -- Entry point
    -- ========================================================================
    {
      "<leader>Ja",
      "<cmd>JsonLogs<CR>",
      desc = "Open JSONL Viewer",
    },

    -- ========================================================================
    -- Navigation
    -- ========================================================================
    { "<leader>Jn", "j", desc = "Next Log Entry", remap = true },
    { "<leader>Jp", "k", desc = "Previous Log Entry", remap = true },
    { "<leader>Jg", "gg", desc = "First Log Entry", remap = true },
    { "<leader>JG", "G", desc = "Last Log Entry", remap = true },

    { "<leader>Je", "]e", desc = "Next Error Log", remap = true },
    { "<leader>JE", "[e", desc = "Previous Error Log", remap = true },

    -- ========================================================================
    -- Pane management
    -- ========================================================================
    { "<leader>Jt", "<Tab>", desc = "Switch Source / Preview", remap = true },
    { "<leader>Jf", "f", desc = "Maximize / Restore Preview", remap = true },

    -- ========================================================================
    -- Preview actions
    -- ========================================================================
    { "<leader>J<CR>", "<CR>", desc = "Toggle Fold / Inspect Cell", remap = true },
    { "<leader>Jy", "y", desc = "Yank Formatted JSON", remap = true },

    -- ========================================================================
    -- Bookmarks
    -- ========================================================================
    { "<leader>Jm", "m", desc = "Bookmark Current Entry", remap = true },
    { "<leader>Jb", "'", desc = "List Bookmarks", remap = true },

    -- ========================================================================
    -- Search and filtering
    -- ========================================================================
    { "<leader>Js", "/", desc = "Search by Field Value", remap = true },

    -- ========================================================================
    -- Display modes
    -- ========================================================================
    { "<leader>Jc", "c", desc = "Toggle Compact View", remap = true },
    { "<leader>JT", "T", desc = "Toggle Table Preview", remap = true },

    -- ========================================================================
    -- Table pagination
    -- ========================================================================
    { "<leader>J]", "]", desc = "Next Table Page", remap = true },
    { "<leader>J[", "[", desc = "Previous Table Page", remap = true },
    { "<leader>J]]", "]]", desc = "Last Table Page", remap = true },
    { "<leader>J[[", "[[", desc = "First Table Page", remap = true },
    { "<leader>JC", "C", desc = "Filter Table Columns", remap = true },

    -- ========================================================================
    -- Analysis
    -- ========================================================================
    { "<leader>Jd", "d", desc = "Mark Entry / Show Diff", remap = true },
    { "<leader>Jl", "t", desc = "Toggle Live Tail", remap = true },
    { "<leader>Jr", "s", desc = "Show Log Statistics", remap = true },

    -- ========================================================================
    -- General
    -- ========================================================================
    { "<leader>Jq", "q", desc = "Close JSONL Viewer", remap = true },
  },
}
