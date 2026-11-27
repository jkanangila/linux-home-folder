-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`

local env = require "env"

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    features = {
      codelens = true,
      inlay_hints = false,
      semantic_tokens = true,
    },
    formatting = {
      format_on_save = {
        enabled = true,
        ignore_filetypes = {},
      },
      disabled = {},
      -- Was 120000 (2 minutes): a hung formatter froze :w that long.
      timeout_ms = env.is_mobile and 30000 or 10000,
    },
    servers = { "basedpyright", "ruff", "jinja_lsp" },
    config = {
      ruff = {
        on_attach = function(client)
          -- Let basedpyright own hover
          client.server_capabilities.hoverProvider = false
        end,
      },
      basedpyright = {
        capabilities = {
          workspace = {
            -- Dynamic file watching is expensive on phones (low inotify limits, slow storage)
            didChangeWatchedFiles = { dynamicRegistration = not env.is_mobile },
          },
        },
        settings = {
          basedpyright = {
            -- Ruff handles import sorting
            disableOrganizeImports = true,
            analysis = {
              diagnosticMode = env.is_mobile and "openFilesOnly" or "workspace",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "standard", -- pyproject.toml overrides this per project
              strictDictionaryInference = true,
              diagnosticSeverityOverrides = {
                reportGeneralTypeIssues = "error",
                -- Ruff reports these; avoid duplicate diagnostics
                reportUnusedImport = "none",
                reportUnusedVariable = "none",
                reportUnusedClass = "none",
                reportUnusedFunction = "none",
              },
            },
          },
        },
      },
      jinja_lsp = {
        filetypes = { "jinja" },
      },
    },
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
  },
}
