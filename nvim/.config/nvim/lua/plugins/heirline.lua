return {
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astroui.status"

      -- Enable partial command/motion rendering inside the statusline (%S)
      vim.opt.showcmdloc = "statusline"

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

      -- 4. Clock (your custom component at far right)
      table.insert(
        opts.statusline,
        status.component.builder {
          provider = function() return " 🕓" .. os.date "%H:%M" end,
          update = {
            "FocusGained",
            "BufEnter",
            "CursorHold",
            "ModeChanged",
          },
        }
      )
    end,
  },
}
