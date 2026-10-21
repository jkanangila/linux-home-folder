return {
  {
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local status = require "astroui.status"

      -- Add a clock at the far right.
      table.insert(
        opts.statusline,
        status.component.builder {
          provider = function() return " 󰥔 " .. os.date "%H:%M" end,
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
