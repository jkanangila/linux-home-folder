---@type LazySpec
return {
  -- Neo-tree is replaced by Oil.
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },

  {
    "stevearc/oil.nvim",
    lazy = false, -- must load at startup to take over `nvim <dir>`

    dependencies = {
      {
        "malewicz1337/oil-git.nvim",
        opts = {
          show_file_highlights = true,
          show_directory_symbols = false,
          show_file_symbols = false,
          show_branch = true,
          show_ignored_files = true, -- runs `git status --ignored`; turn off if huge repos feel slow
        },
      },
    },

    opts = {
      default_file_explorer = true,
      -- pymple.nvim fixes Python imports on rename instead
      lsp_file_methods = { enabled = false },
      -- Show everything. (The old `is_hidden_file = function() return false end` made `g.` a no-op.)
      view_options = { show_hidden = true },
    },

    -- Initialize empty Jupyter notebooks BEFORE jupytext.nvim reads them.
    -- BufReadPre runs before the BufReadCmd that jupytext uses for .ipynb files.
    init = function()
      vim.api.nvim_create_autocmd("BufReadPre", {
        pattern = "*.ipynb",
        desc = "Initialize empty Jupyter notebooks before Jupytext",
        callback = function(args)
          local path = args.match
          local stat = vim.uv.fs_stat(path)
          if not stat or stat.type ~= "file" or stat.size ~= 0 then return end

          -- Literal JSON: vim.json.encode({}) emits `{}` for an empty list, which makes `cells` an
          -- object and the notebook invalid.
          local notebook = '{"cells":[],"metadata":{},"nbformat":4,"nbformat_minor":5}\n'

          local ok, err = pcall(function()
            local fd = assert(vim.uv.fs_open(path, "w", 420)) -- 0644
            assert(vim.uv.fs_write(fd, notebook, -1))
            assert(vim.uv.fs_close(fd))
          end)

          if not ok then
            vim.schedule(
              function() vim.notify(("Unable to initialize notebook:\n%s"):format(err), vim.log.levels.ERROR) end
            )
          end
        end,
      })
    end,
  },

  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          ["<Leader>o"] = { desc = "Oil" },

          ["<Leader>e"] = {
            function() require("oil").toggle_float() end,
            desc = "Oil (floating)",
          },

          ["<Leader>oo"] = {
            function()
              if vim.bo.filetype == "oil" then
                require("oil").close()
              else
                require("oil").open() -- directory of the current file
              end
            end,
            desc = "Toggle Oil (current file's dir)",
          },

          ["<Leader>or"] = {
            function()
              if vim.bo.filetype == "oil" then
                require("oil").close()
              else
                -- Was `open(".")`, which is just the cwd, not the project root.
                local root = vim.fs.root(0, { ".git", "pyproject.toml", "package.json" }) or vim.uv.cwd()
                require("oil").open(root)
              end
            end,
            desc = "Toggle Oil (project root)",
          },

          ["<Leader>oj"] = {
            function()
              if vim.bo.filetype ~= "oil" then
                vim.notify("Jupyter scratchpad can only be created from Oil", vim.log.levels.WARN)
                return
              end

              local dir = require("oil").get_current_dir()
              if not dir then
                vim.notify("Unable to determine Oil directory", vim.log.levels.ERROR)
                return
              end

              local filename = ("scratch_%s.py"):format(os.date "%Y%m%d_%H%M%S")
              vim.cmd.edit(vim.fn.fnameescape(vim.fs.joinpath(dir, filename)))
              vim.bo.filetype = "python"

              -- First Jupyter cell
              vim.api.nvim_buf_set_lines(0, 0, -1, false, { "# %%", "" })
              vim.api.nvim_win_set_cursor(0, { 2, 0 })

              vim.notify(("Created Jupyter scratchpad: %s"):format(filename), vim.log.levels.INFO)
            end,
            desc = "New Jupyter Python scratchpad",
          },

          -- CSpell for file names. Moved from <Leader>c*: <Leader>c is AstroNvim's "close buffer",
          -- so sharing the prefix made every buffer close wait for 'timeoutlen'.
          ["<Leader>os"] = {
            function() require("oil-cspell").check_current() end,
            desc = "CSpell: check filename",
          },
          ["<Leader>oa"] = {
            function()
              if vim.bo.filetype == "oil" then require("oil-cspell").code_actions() end
            end,
            desc = "CSpell: suggestions",
          },
          ["<Leader>oS"] = {
            function()
              if vim.bo.filetype == "oil" then require("oil-cspell").clear() end
            end,
            desc = "CSpell: clear diagnostic",
          },
        },
      },
    },
  },
}
