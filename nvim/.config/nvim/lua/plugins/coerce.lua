return {
  {
    "gregorias/coerce.nvim",
    tag = "v5.0.0",
    event = "VeryLazy",

    config = function() require("coerce").setup() end,

    keys = {
      {
        "cr",
        "<Plug>(coerce-normal)",
        mode = "n",
        desc = "Coerce word",
      },
      {
        "gcr",
        "<Plug>(coerce-motion)",
        mode = "n",
        desc = "Coerce motion",
      },
      {
        "gcr",
        "<Plug>(coerce-visual)",
        mode = "x",
        desc = "Coerce visual",
      },
    },
  },
}
