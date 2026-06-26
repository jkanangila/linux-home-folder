return {
  "nemanjamalesija/smart-paste.nvim",
  -- Lazy load on pasting keymaps
  keys = { "p", "P", "[p", "]p", "gp", "gP" },
  config = function()
    -- Automatically setups default behavior
    require("smart-paste").setup {}
  end,
}
