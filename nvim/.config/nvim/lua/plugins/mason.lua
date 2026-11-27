local env = require "env"

-- Mason's prebuilt binaries are glibc builds and fail on Termux (bionic).
-- There, install tools with the package manager instead:
--   pkg install lua-language-server stylua tree-sitter nodejs && npm i -g cspell
local tools = env.is_termux and {}
  or {
    -- language servers
    "lua-language-server",
    "jinja-lsp",
    -- formatters
    "stylua",
    -- other
    "tree-sitter-cli",
    "cspell",
  }

---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = { ensure_installed = tools }, -- names as shown in :Mason
  },
}
