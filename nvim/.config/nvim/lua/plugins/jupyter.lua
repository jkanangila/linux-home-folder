return {
  -- Molten-nvim: Interactive kernel execution and output display
  {
    "benlubas/molten-nvim",
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_wrap_output = true
      vim.g.molten_auto_open_output = false
      vim.g.molten_virt_text_output = true
    end,
    keys = {
      { "<leader>j", desc = "📓 Jupyter / Molten", mode = { "n", "v" } },

      { "<leader>ji", ":MoltenInit<CR>", desc = "Initialize Kernel" },
      { "<leader>je", ":MoltenEvaluateOperator<CR>", desc = "Evaluate Operator" },
      { "<leader>jl", ":MoltenEvaluateLine<CR>", desc = "Evaluate Line" },

      {
        "<leader>jr",
        function()
          local cur_pos = vim.api.nvim_win_get_cursor(0)

          local start_line = vim.fn.search("^# %%", "bcnW")
          if start_line == 0 then start_line = 1 end

          local end_line = vim.fn.search("^# %%", "nW")
          if end_line == 0 then
            end_line = vim.fn.line "$"
          else
            end_line = end_line - 1
          end

          if end_line < start_line then end_line = start_line end

          vim.api.nvim_win_set_cursor(0, { start_line, 0 })
          vim.cmd "normal! V"
          vim.api.nvim_win_set_cursor(0, { end_line, 0 })
          vim.cmd "MoltenEvaluateVisual"

          vim.api.nvim_win_set_cursor(0, cur_pos)
        end,
        desc = "Run Cell (Inline Output)",
      },

      { "<leader>jo", ":MoltenShowOutput<CR>", desc = "Open Output Window" },
      { "<leader>jh", ":MoltenHideOutput<CR>", desc = "Hide Output Window" },
      { "<leader>jd", ":MoltenDelete<CR>", desc = "Delete/Clear Cell Output" },
      { "<leader>jR", ":MoltenReevaluateCell<CR>", desc = "Re-evaluate Molten Cell" },
      { "<leader>jx", ":MoltenInterrupt<CR>", desc = "Interrupt Kernel" },
      { "<leader>jv", ":<C-u>MoltenEvaluateVisual<CR>gv", mode = "v", desc = "Evaluate Visual Selection" },

      -- UPDATED JUPYTEXT COMMANDS (Injects kernel metadata to prevent nil error)
      {
        "<leader>jc",
        "<cmd>!jupytext --to ipynb --set-kernel python3 %<CR>",
        desc = "Convert current .py to .ipynb",
      },
      {
        "<leader>jp",
        "<cmd>!jupytext --set-formats ipynb,py:percent --set-kernel python3 --sync %<CR>",
        desc = "Pair & Sync .py with .ipynb",
      },
    },
  },

  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    opts = {
      custom_language_formatting = {
        python = {
          extension = "py",
          style = "percent",
          force_ft = "python",
        },
      },
    },
  },
}
