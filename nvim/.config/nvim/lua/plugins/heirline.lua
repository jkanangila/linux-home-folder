return {
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astroui.status"

      -- showcmdloc = "statusline" is set in astrocore.lua (options.opt)

      -- 1. Search count component
      local search_count = status.component.builder {
        provider = function()
          local ok, res = pcall(vim.fn.searchcount, { recompute = 1, maxcount = 999, timeout = 100 })
          if ok and res.total > 0 and vim.v.hlsearch == 1 then
            return string.format(" [%d/%d] ", res.current, res.total)
          end
          return ""
        end,
        update = { "CursorMoved", "CursorMovedI", "ModeChanged", "CmdlineChanged", "CmdlineLeave" },
        hl = { fg = "orange", bold = false },
      }

      -- 2. Pending motion/cmd component (e.g., "24", "24G", "d")
      local show_cmd = status.component.builder {
        provider = " %S",
        hl = { bold = true },
      }

      -- 3. Line & Column/Character position (e.g., "Ln 10, Col 50")
      local line_col_position = status.component.builder {
        provider = " %l:%c ",
      }

      -- Insert components into the statusline layout
      table.insert(opts.statusline, search_count)
      table.insert(opts.statusline, show_cmd)
      table.insert(opts.statusline, line_col_position)

      -- 4. Clock (far right). Heirline caches components that have `update`, so a timer fires a
      -- User event every minute; before this the clock only moved on BufEnter/CursorHold/etc.
      if not vim.g._heirline_clock_timer then
        vim.g._heirline_clock_timer = true
        local function tick() vim.api.nvim_exec_autocmds("User", { pattern = "HeirlineClockTick", modeline = false }) end
        vim.uv.new_timer():start(60000, 60000, vim.schedule_wrap(tick))
        vim.api.nvim_create_autocmd("FocusGained", { callback = tick })
      end

      table.insert(
        opts.statusline,
        status.component.builder {
          -- Nerd Font glyph; the 🕓 emoji has unreliable cell width in Termux and other terminals
          provider = function() return " 󰥔 " .. os.date "%H:%M" end,
          update = { "User", pattern = "HeirlineClockTick" },
        }
      )
    end,
  },
}
