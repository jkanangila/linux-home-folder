---@type LazySpec

return {
  -- ============================================================================
  -- Disable Neo-tree
  -- ============================================================================

  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },

  -- ============================================================================
  -- Oil
  -- ============================================================================

  {
    "stevearc/oil.nvim",

    lazy = false,

    dependencies = {
      {
        "malewicz1337/oil-git.nvim",

        opts = {
          show_file_highlights = true,
          show_directory_symbols = false,
          show_file_symbols = false,
          show_branch = true,
          show_ignored_files = true,
        },
      },
    },

    opts = {
      default_file_explorer = true,

      lsp_file_methods = {
        enabled = false,
      },

      view_options = {
        show_hidden = true,

        is_hidden_file = function(_, _) return false end,
      },
    },

    -- ========================================================================
    -- Initialize empty Jupyter notebooks before Jupytext reads them.
    -- ========================================================================

    init = function()
      local function initialize_empty_notebook()
        local path = vim.fn.expand "<amatch>"

        -- Only handle .ipynb files.
        if not path:match "%.ipynb$" then return end

        -- Don't interfere with nonexistent files.
        if vim.fn.filereadable(path) ~= 1 then return end

        -- Only initialize genuinely empty files.
        local stat = vim.uv.fs_stat(path)

        if not stat or stat.size ~= 0 then return end

        local notebook = vim.json.encode {
          cells = {},
          metadata = {},
          nbformat = 4,
          nbformat_minor = 5,
        }

        local ok, err = pcall(function()
          local fd = assert(vim.uv.fs_open(path, "w", 420))
          assert(vim.uv.fs_write(fd, notebook, -1))
          assert(vim.uv.fs_close(fd))
        end)

        if not ok then
          vim.schedule(
            function() vim.notify(("Unable to initialize notebook:\n%s"):format(err), vim.log.levels.ERROR) end
          )
        end
      end

      -- BufReadPre happens before BufReadCmd.
      --
      -- This is important because jupytext.nvim uses BufReadCmd for
      -- .ipynb files. We must make the JSON valid BEFORE Jupytext
      -- attempts to decode it.
      vim.api.nvim_create_autocmd("BufReadPre", {
        pattern = "*.ipynb",
        callback = initialize_empty_notebook,
        desc = "Initialize empty Jupyter notebooks before Jupytext",
      })
    end,
  },

  -- ============================================================================
  -- AstroCore
  -- ============================================================================

  {
    "AstroNvim/astrocore",

    opts = function(_, opts)
      local oil = require "oil"
      local oil_cspell = require "oil-cspell"

      opts.mappings = opts.mappings or {}
      opts.mappings.n = opts.mappings.n or {}

      local mappings = opts.mappings.n

      -- ========================================================================
      -- Oil
      -- ========================================================================

      mappings["<leader>o"] = {
        desc = "Oil File Explorer",
      }

      mappings["<leader>oo"] = {
        function()
          if vim.bo.filetype == "oil" then
            oil.close()
          else
            oil.open()
          end
        end,

        desc = "Toggle Oil (Current Dir)",
      }

      mappings["<leader>or"] = {
        function()
          if vim.bo.filetype == "oil" then
            oil.close()
          else
            oil.open "."
          end
        end,

        desc = "Toggle Oil (Project Root)",
      }

      -- ========================================================================
      -- Jupyter scratchpad
      -- ========================================================================

      mappings["<leader>oj"] = {
        function()
          if vim.bo.filetype ~= "oil" then
            vim.notify("Jupyter scratchpad can only be created from Oil", vim.log.levels.WARN)

            return
          end

          local dir = oil.get_current_dir()

          if not dir then
            vim.notify("Unable to determine Oil directory", vim.log.levels.ERROR)

            return
          end

          local filename = ("scratch_%s.py"):format(os.date "%Y%m%d_%H%M%S")

          local path = vim.fs.joinpath(dir, filename)

          -- Create the Python scratchpad.
          vim.cmd.edit(vim.fn.fnameescape(path))

          vim.bo.filetype = "python"

          -- Insert the first Jupyter cell.
          vim.api.nvim_buf_set_lines(0, 0, -1, false, {
            "# %%",
            "",
          })

          vim.api.nvim_win_set_cursor(0, { 2, 0 })

          vim.notify(("Created Jupyter scratchpad: %s"):format(filename), vim.log.levels.INFO)
        end,

        desc = "New Jupyter Python Scratchpad",
      }

      -- ========================================================================
      -- CSpell
      -- ========================================================================

      mappings["<leader>cs"] = {
        function()
          if vim.bo.filetype ~= "oil" then
            vim.notify("CSpell filename checking is only available in Oil", vim.log.levels.WARN)

            return
          end

          oil_cspell.check_current()
        end,

        desc = "CSpell: Check Filename",
      }

      mappings["<leader>ca"] = {
        function()
          if vim.bo.filetype ~= "oil" then return end

          oil_cspell.code_actions()
        end,

        desc = "CSpell: Suggestions",
      }

      mappings["<leader>cS"] = {
        function()
          if vim.bo.filetype ~= "oil" then return end

          oil_cspell.clear()
        end,

        desc = "CSpell: Clear Diagnostic",
      }
    end,
  },
}
