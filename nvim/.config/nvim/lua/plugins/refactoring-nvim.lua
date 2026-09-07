return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "lewis6991/async.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = false,
    opts = {},
    keys = {
      {
        "<leader>re",
        function() return require("refactoring").extract_func_to_file() end,
        mode = { "n", "x" },
        desc = "Extract function to file",
        expr = true,
      },
      {
        "<leader>rf",
        function() return require("refactoring").extract_func() end,
        mode = { "n", "x" },
        desc = "Extract function",
        expr = true,
      },
      {
        "<leader>rv",
        function() return require("refactoring").extract_var() end,
        mode = { "n", "x" },
        desc = "Extract variable",
        expr = true,
      },
      {
        "<leader>ri",
        function() return require("refactoring").inline_var() end,
        mode = { "n", "x" },
        desc = "Inline variable",
        expr = true,
      },
    },
  },
}
