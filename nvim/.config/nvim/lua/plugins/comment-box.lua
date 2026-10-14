return {
  "LudoPinelli/comment-box.nvim",
  lazy = false,

  config = function()
    -- Register the group using the Which-Key v3 API.
    require("which-key").add {
      { "<leader>B", group = "Comment Boxes" },
    }
  end,

  keys = {
    -- ============================================================
    -- Fixed-width boxes
    -- ============================================================

    -- Left-aligned box
    { "<leader>Bll", "<cmd>CBllbox<cr>", mode = { "n", "v" }, desc = "Left Box / Left Text" },
    { "<leader>Blc", "<cmd>CBlcbox<cr>", mode = { "n", "v" }, desc = "Left Box / Center Text" },
    { "<leader>Blr", "<cmd>CBlrbox<cr>", mode = { "n", "v" }, desc = "Left Box / Right Text" },

    -- Centered box
    { "<leader>Bcl", "<cmd>CBclbox<cr>", mode = { "n", "v" }, desc = "Center Box / Left Text" },
    { "<leader>Bcc", "<cmd>CBccbox<cr>", mode = { "n", "v" }, desc = "Center Box / Center Text" },
    { "<leader>Bcr", "<cmd>CBcrbox<cr>", mode = { "n", "v" }, desc = "Center Box / Right Text" },

    -- Right-aligned box
    { "<leader>Brl", "<cmd>CBrlbox<cr>", mode = { "n", "v" }, desc = "Right Box / Left Text" },
    { "<leader>Brc", "<cmd>CBrcbox<cr>", mode = { "n", "v" }, desc = "Right Box / Center Text" },
    { "<leader>Brr", "<cmd>CBrrbox<cr>", mode = { "n", "v" }, desc = "Right Box / Right Text" },

    -- ============================================================
    -- Adapted-width boxes
    -- ============================================================

    { "<leader>Bal", "<cmd>CBlabox<cr>", mode = { "n", "v" }, desc = "Adapted Box (Left)" },
    { "<leader>Bac", "<cmd>CBacbox<cr>", mode = { "n", "v" }, desc = "Adapted Box (Center)" },
    { "<leader>Bar", "<cmd>CBrabox<cr>", mode = { "n", "v" }, desc = "Adapted Box (Right)" },

    -- ============================================================
    -- Titled lines
    -- ============================================================

    { "<leader>Btl", "<cmd>CBllline<cr>", mode = { "n", "v" }, desc = "Titled Line (Left)" },
    { "<leader>Btc", "<cmd>CBclline<cr>", mode = { "n", "v" }, desc = "Titled Line (Center)" },
    { "<leader>Btr", "<cmd>CBrrline<cr>", mode = { "n", "v" }, desc = "Titled Line (Right)" },

    -- ============================================================
    -- Simple lines
    -- ============================================================

    { "<leader>Bl", "<cmd>CBline<cr>", mode = "n", desc = "Simple Line (Left)" },
    { "<leader>Bc", "<cmd>CBcline<cr>", mode = "n", desc = "Simple Line (Center)" },
    { "<leader>Br", "<cmd>CBrline<cr>", mode = "n", desc = "Simple Line (Right)" },

    -- ============================================================
    -- Utilities
    -- ============================================================

    { "<leader>Bd", "<cmd>CBd<cr>", mode = { "n", "v" }, desc = "Delete Box / Titled Line" },
    { "<leader>By", "<cmd>CBy<cr>", mode = { "n", "v" }, desc = "Yank Box Content" },
    { "<leader>Bo", "<cmd>CBcatalog<cr>", mode = "n", desc = "Open Style Catalog" },
  },
}
