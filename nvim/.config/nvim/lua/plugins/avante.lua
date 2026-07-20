local utils = require "utils"

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false,
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = { file_types = { "markdown", "Avante" } },
      ft = { "markdown", "Avante" },
    },
  },
  opts = {
    provider = "ollama",
    auto_suggestions_provider = "ollama",
    providers = {
      ollama = {
        endpoint = "http://" .. utils.host_ip .. ":11434",
        model = "qwen2.5-coder:1.5b",
      },
    },
  },
}
