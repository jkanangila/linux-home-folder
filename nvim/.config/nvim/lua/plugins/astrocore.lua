-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--        as this provides autocomplete and documentation while editing

local env = require "env"
-- Determine the correct clipboard configuration based on the environment
local clipboard_config = {}
if env.os == "linux" and env.is_wsl then
  clipboard_config = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 0,
  }
elseif env.os == "linux" and env.is_chroot then
  clipboard_config = {
    name = "lemonade",
    copy = {
      -- Redirect stdout and stderr to /dev/null for silent copying
      ["+"] = { "sh", "-c", "lemonade copy > /dev/null 2>&1" },
      ["*"] = { "sh", "-c", "lemonade copy > /dev/null 2>&1" },
    },
    paste = {
      -- Suppress stderr logs, but preserve stdout (the clipboard data)
      ["+"] = { "sh", "-c", "lemonade paste 2> /dev/null" },
      ["*"] = { "sh", "-c", "lemonade paste 2> /dev/null" },
    },
    cache_enabled = 1,
  }
elseif env.os == "linux" and env.is_termux then
  clipboard_config = {
    name = "Termux Clipboard",
    copy = {
      ["+"] = "termux-clipboard-set",
      ["*"] = "termux-clipboard-set",
    },
    paste = {
      ["+"] = "termux-clipboard-get",
      ["*"] = "termux-clipboard-get",
    },
    cache_enabled = 0,
  }
else
  clipboard_config = nil
end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = false, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap (Required: horizontal scroll won't work on wrapped lines!)
        clipboard = "unnamedplus", -- standard desktop clipboard (the one used by Ctrl+C / Ctrl+V)

        -- Scrolling & Touch Settings
        mouse = "a",        -- Enable full mouse support (lets Termux pass touch gestures to Neovim)
        sidescroll = 1,     -- Scroll horizontal column-by-column for smoother panning
        sidescrolloff = 8,  -- Keeps the cursor centered with an 8-character buffer on sides
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
        clipboard = clipboard_config,
      },
    },

    -- Register custom vim user commands
    commands = {

    },

    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- Normal mode mappings
      n = {
        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- FIXED: Capitalized <Leader> to match AstroNvim standards
        ["<Leader>sv"] = { "<cmd>source $MYVIMRC<cr>", desc = "Reload Neovim Config" },

        -- Custom binding for our native-safe LSP restart command
        ["<Leader>ln"] = { "<cmd>lsp restart<cr>", desc = "Restart LSP" },

        -- Shift + Scroll Wheel mappings for horizontal scrolling (5 columns at a time)
        ["<S-ScrollWheelUp>"]   = { "5zh", desc = "Scroll screen left" },
        ["<S-ScrollWheelDown>"] = { "5zl", desc = "Scroll screen right" },

        -- Mobile Trackpad / Swiping horizontal mouse events
        ["<ScrollWheelLeft>"]   = { "5zh", desc = "Scroll left" },
        ["<ScrollWheelRight>"]  = { "5zl", desc = "Scroll right" },
      },

      -- Visual mode mappings (keeps scrolling functional without breaking active selections)
      v = {
        ["<S-ScrollWheelUp>"]   = { "5zh" },
        ["<S-ScrollWheelDown>"] = { "5zl" },
        ["<ScrollWheelLeft>"]   = { "5zh" },
        ["<ScrollWheelRight>"]  = { "5zl" },
      },
    },
  },
}
