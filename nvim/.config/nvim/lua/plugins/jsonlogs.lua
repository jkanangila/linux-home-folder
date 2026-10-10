return {
  "ll931217/jsonlogs.nvim",
  ft = "jsonl",

  opts = {
    prefix = "<leader>J",
    auto_open = true,
  },

  keys = {
    -- ========================================================================
    -- Entry point
    -- ========================================================================
    { "<leader>Ja", "<cmd>JsonLogs<CR>", desc = "Open JSONL viewer" },

    -- ========================================================================
    -- Navigation
    -- ========================================================================
    { "<leader>Jn", "j", desc = "Next log entry", remap = true },
    { "<leader>Jp", "k", desc = "Previous log entry", remap = true },
    { "<leader>Jg", "gg", desc = "First log entry", remap = true },
    { "<leader>JG", "G", desc = "Last log entry", remap = true },
    { "<leader>J]", "]e", desc = "Next error log", remap = true },
    { "<leader>J[", "[e", desc = "Previous error log", remap = true },

    -- ========================================================================
    -- Pane management
    -- ========================================================================
    { "<leader>Jt", "<Tab>", desc = "Toggle source/preview pane", remap = true },
    { "<leader>Jf", "f", desc = "Maximize/restore preview", remap = true },

    -- ========================================================================
    -- Preview actions
    -- ========================================================================
    { "<leader>J<CR>", "<CR>", desc = "Toggle fold / inspect cell", remap = true },
    { "<leader>Jy", "y", desc = "Yank formatted JSON", remap = true },

    -- ========================================================================
    -- Bookmarks
    -- ========================================================================
    { "<leader>Jm", "m", desc = "Bookmark current line", remap = true },
    { "<leader>Jb", "'", desc = "List bookmarks", remap = true },

    -- ========================================================================
    -- Search and filter
    -- ========================================================================
    { "<leader>Js", "/", desc = "Search by field value", remap = true },

    -- ========================================================================
    -- Display modes
    -- ========================================================================
    { "<leader>Jc", "c", desc = "Toggle compact view", remap = true },
    { "<leader>JT", "T", desc = "Toggle table preview", remap = true },

    -- ========================================================================
    -- Table pagination
    -- ========================================================================
    { "<leader>J]", "]", desc = "Next table page", remap = true },
    { "<leader>J[", "[", desc = "Previous table page", remap = true },
    { "<leader>J]]", "]]", desc = "Last table page", remap = true },
    { "<leader>J[[", "[[", desc = "First table page", remap = true },
    { "<leader>JC", "C", desc = "Open column filter", remap = true },

    -- ========================================================================
    -- Analysis
    -- ========================================================================
    { "<leader>Jd", "d", desc = "Mark/show diff", remap = true },
    { "<leader>Jl", "t", desc = "Toggle live tail", remap = true },
    { "<leader>Jr", "s", desc = "Show log statistics", remap = true },

    -- ========================================================================
    -- General
    -- ========================================================================
    { "<leader>Jq", "q", desc = "Close JSONL viewer", remap = true },
  },
}
