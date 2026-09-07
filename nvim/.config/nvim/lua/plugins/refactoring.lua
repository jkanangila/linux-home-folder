return {
  {
    "ThePrimeagen/refactoring.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "lewis6991/async.nvim",
    },
    config = function() require("refactoring").setup {} end,
    keys = {
      -- Helper function to safely save normal file buffers
      {
        "<leader>re",
        function()
          require("refactoring").refactor "Extract Function To File"
          vim.schedule(function()
            if vim.bo.buftype == "" and vim.bo.modified then vim.cmd "silent! write" end
          end)
        end,
        mode = "v",
        desc = "Extract selection to separate file",
      },
      {
        "<leader>rf",
        function()
          require("refactoring").refactor "Extract Function"
          vim.schedule(function()
            if vim.bo.buftype == "" and vim.bo.modified then vim.cmd "silent! write" end
          end)
        end,
        mode = "v",
        desc = "Extract function within file",
      },
      {
        "<leader>rv",
        function()
          require("refactoring").refactor "Extract Variable"
          vim.schedule(function()
            if vim.bo.buftype == "" and vim.bo.modified then vim.cmd "silent! write" end
          end)
        end,
        mode = "v",
        desc = "Extract selection to variable",
      },
      {
        "<leader>ri",
        function()
          require("refactoring").refactor "Inline Variable"
          vim.schedule(function()
            if vim.bo.buftype == "" and vim.bo.modified then vim.cmd "silent! write" end
          end)
        end,
        mode = { "n", "v" },
        desc = "Inline target variable",
      },
    },
  },
}
