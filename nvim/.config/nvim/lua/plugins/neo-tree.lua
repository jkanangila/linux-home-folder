return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,          -- Ensures filtered items remain visible (dimmed out)
        hide_dotfiles = false,    -- Sets dotfiles (.bashrc, .gitignore, etc.) to permanently show
        hide_gitignored = false,  -- Optional: Set to false if you want to see gitignored files too
      },
    },
  },
}
