-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`

local env = require "env"

--- Clipboard provider per device. Returning nil keeps Neovim's own auto-detection
--- (wl-clipboard / xclip / win32yank / pbcopy), which is right for CachyOS and other desktops.
---@return table?
local function clipboard_config()
  if env.is_wsl and vim.fn.executable "win32yank.exe" == 1 then
    return {
      name = "win32yank-wsl",
      copy = { ["+"] = "win32yank.exe -i --crlf", ["*"] = "win32yank.exe -i --crlf" },
      paste = { ["+"] = "win32yank.exe -o --lf", ["*"] = "win32yank.exe -o --lf" },
      cache_enabled = 0,
    }
  end

  if env.is_chroot and vim.fn.executable "lemonade" == 1 then
    return {
      name = "lemonade",
      copy = {
        -- Redirect stdout/stderr to /dev/null for silent copying
        ["+"] = { "sh", "-c", "lemonade copy > /dev/null 2>&1" },
        ["*"] = { "sh", "-c", "lemonade copy > /dev/null 2>&1" },
      },
      paste = {
        -- Suppress stderr logs, keep stdout (the clipboard data)
        ["+"] = { "sh", "-c", "lemonade paste 2> /dev/null" },
        ["*"] = { "sh", "-c", "lemonade paste 2> /dev/null" },
      },
      cache_enabled = 1,
    }
  end

  if env.is_termux and vim.fn.executable "termux-clipboard-set" == 1 then
    return {
      name = "Termux Clipboard",
      copy = { ["+"] = "termux-clipboard-set", ["*"] = "termux-clipboard-set" },
      paste = { ["+"] = "termux-clipboard-get", ["*"] = "termux-clipboard-get" },
      cache_enabled = 0,
    }
  end

  -- Over SSH (or any box without a clipboard tool) fall back to OSC 52: yanks reach the local terminal.
  if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
    local osc52 = require "vim.ui.clipboard.osc52"
    -- Pasting via OSC 52 is unreliable; paste from the unnamed register instead.
    local function paste() return { vim.fn.split(vim.fn.getreg "", "\n"), vim.fn.getregtype "" } end
    return {
      name = "OSC 52",
      copy = { ["+"] = osc52.copy "+", ["*"] = osc52.copy "*" },
      paste = { ["+"] = paste, ["*"] = paste },
    }
  end

  return nil
end

-- Horizontal scrolling: Shift+wheel and trackpad / touch swipes (5 columns at a time).
local function horizontal_scroll()
  return {
    ["<S-ScrollWheelUp>"] = { "5zh", desc = "Scroll screen left" },
    ["<S-ScrollWheelDown>"] = { "5zl", desc = "Scroll screen right" },
    ["<ScrollWheelLeft>"] = { "5zh", desc = "Scroll left" },
    ["<ScrollWheelRight>"] = { "5zl", desc = "Scroll right" },
  }
end

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- disable heavy features on big files
      autopairs = true,
      cmp = true,
      diagnostics = { virtual_text = true, virtual_lines = false },
      highlighturl = true,
      notifications = true,
    },
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    filetypes = {
      extension = {
        j2 = "jinja",
        jinja = "jinja",
        jinja2 = "jinja",
      },
    },
    options = {
      opt = {
        relativenumber = false,
        number = true,
        spell = false,
        signcolumn = "yes",
        wrap = false, -- required: horizontal scroll does not work on wrapped lines
        clipboard = "unnamedplus",
        showcmdloc = "statusline", -- pending keys are rendered by the heirline %S component

        -- Scrolling & touch
        mouse = "a", -- lets Termux pass touch gestures to Neovim
        sidescroll = 1,
        sidescrolloff = 8,
      },
      g = {
        -- NOTE: `mapleader` / `maplocalleader` live in lua/lazy_setup.lua
        clipboard = clipboard_config(),
      },
    },

    commands = {},

    -- NOTE: keycodes follow the casing in the vimdocs; `<Leader>` must be capitalized.
    -- ]b / [b and <Leader>bd are AstroNvim defaults, so they are not repeated here.
    mappings = {
      n = vim.tbl_extend("error", horizontal_scroll(), {
        -- Native LSP restart (`:lsp restart` needs a recent Neovim)
        ["<Leader>ln"] = { "<cmd>lsp restart<cr>", desc = "Restart LSP" },
      }),
      -- Keeps scrolling functional without breaking active selections
      v = horizontal_scroll(),
    },
  },
}
