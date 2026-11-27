return {
  {
    "alexpasmantier/pymple.nvim",
    -- nvim-web-devicons and dressing.nvim were removed: AstroNvim 6 mocks devicons through mini.icons
    -- and uses snacks for vim.ui.*, so these only pulled in a second, competing icon plugin.
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    build = ":PympleBuild",
    config = function() require("pymple").setup() end,
  },
}
