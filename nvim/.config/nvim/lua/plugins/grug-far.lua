-- Global search and replace provider
return {
  "MagicDuck/grug-far.nvim",
  config = function()
    require("grug-far").setup {
      -- Overriding the buffer-local keymaps
      keymaps = {
        -- Change execute replace from \r to <leader>r
        replace = { n = "<leader>r" },
        -- Or you can map it to something like <localleader>R
        -- replace = { n = ",r" },

        -- Keeps standard helper utilities clear
        help = { n = "g?" },
      },
    }
  end,
  keys = {
    { "<leader>sr", "<cmd>GrugFar<cr>", desc = "Search and Replace Workspace" },
  },
}
