return {
  "LudoPinelli/comment-box.nvim",
  lazy = false,
  -- Trigger the plugin to load only when you invoke these keys
  keys = {
    -- Normal Mode
    { "<leader>bb", "<cmd>CBccbox<cr>", mode = "n", desc = "Box Title (Centered)" },
    { "<leader>bl", "<cmd>CBllbox<cr>", mode = "n", desc = "Box Title (Left Aligned)" },
    { "<leader>bd", "<cmd>CBd<cr>", mode = "n", desc = "Remove Box" },

    -- Visual Mode (Highlight text blocks first)
    { "<leader>bb", "<cmd>CBccbox<cr>", mode = "v", desc = "Box Selection (Centered)" },
    { "<leader>bl", "<cmd>CBllbox<cr>", mode = "v", desc = "Box Selection (Left Aligned)" },
  },
}
