return {
  "stevearc/oil.nvim",
  dependencies = {
    {
      "antosha417/nvim-lsp-file-operations",
      config = true,
    },
  },
  opts = {
    lsp_file_methods = {
      -- Increase timeout from 2000ms to 10000ms (10 seconds)
      timeout_ms = 120000,
      -- Set to true to autosave buffers that are updated by the LSP
      autosave_changes = true,
    },
  },
  lazy = false,
}
