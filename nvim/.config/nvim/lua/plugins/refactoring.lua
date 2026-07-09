
return {
  {
    "ThePrimeagen/refactoring.nvim",
    lazy = false, -- Keep loaded to protect visual mode bindings
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "lewis6991/async.nvim",
    },
    config = function()
      require("refactoring").setup({})

      -- Monitor buffer edits to refresh basedpyright instantly
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.py",
        callback = function()
          -- Safely locate and reload basedpyright when you write a file
          for _, client in ipairs(vim.lsp.get_clients({ name = "basedpyright" })) do
            -- Trigger an immediate, seamless hot-reload of the language server engine
            vim.cmd("LspRestart basedpyright")
          end
        end,
      })
    end,
    keys = {
      -- 1. Extract block/function to a BRAND NEW FILE (with post-save trigger)
      {
        "<leader>re",
        function()
          -- Use a deferred schedule to execute the save command immediately after refactoring processes
          vim.schedule(function()
            vim.cmd("wa")
          end)
          return require("refactoring").extract_func_to_file()
        end,
        mode = "v",
        expr = true,
        desc = "Extract selection to separate file",
      },

      -- 2. Extract block/function within the SAME FILE
      {
        "<leader>rf",
        function()
          vim.schedule(function()
            vim.cmd("w")
          end)
          return require("refactoring").extract_func()
        end,
        mode = "v",
        expr = true,
        desc = "Extract function within file",
      },

      -- 3. Extract code fragment into a variable
      {
        "<leader>rv",
        function()
          vim.schedule(function()
            vim.cmd("w")
          end)
          return require("refactoring").extract_var()
        end,
        mode = "v",
        expr = true,
        desc = "Extract selection to variable",
      },

      -- 4. Inline an existing variable
      {
        "<leader>ri",
        function()
          vim.schedule(function()
            vim.cmd("w")
          end)
          return require("refactoring").inline_var()
        end,
        mode = { "n", "v" },
        expr = true,
        desc = "Inline target variable",
      },
    },
  },
}
