return {
  {
    "atdma/caelestia-nvim",
    name = "caelestia",
    priority = 1000,
    lazy = false,

    opts = {},

    config = function(_, opts)
      require("caelestia").setup(opts)
      vim.cmd.colorscheme "caelestia"
    end,
  },
}
