-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      format_on_save = {
        enabled = true,
        allow_filetypes = {},
        ignore_filetypes = {},
      },
      disabled = {},
      timeout_ms = 120000,
    },
    servers = {},
    -- customize language server configuration passed to `vim.lsp.config`
    config = {
      -- Let Ruff do the linting and organize imports
      basedpyright = {
        -- ─── CRITICAL FIX FOR FILE OPERATIONS ─────────────────────────────────
        -- We extract the capabilities table safely inline here to satisfy the type checker.
        capabilities = vim.tbl_deep_extend("force", {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        }, package.loaded["lsp-file-operations"] and require("lsp-file-operations").default_config() or {}),
        -- ──────────────────────────────────────────────────────────────────────
        settings = {
          basedpyright = {
            -- Disable duplicate features handled by Ruff
            disableOrganizeImports = true,
            analysis = {
              -- Ensures basedpyright constantly indexes the whole tree
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
            },
          },
          python = {
            analysis = {
              typeCheckingMode = "off",
            },
          },
        },
      },
    },
    handlers = {},
    autocmds = {
      lsp_codelens_refresh = {
        cond = "textDocument/codeLens",
        {
          event = { "InsertLeave", "BufEnter" },
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.enable(true, { bufnr = args.buf }) end
          end,
        },
      },
    },
    mappings = {
      n = {
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client:supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
          end,
        },
      },
    },
    on_attach = function(client, bufnr) end,
  },
}
