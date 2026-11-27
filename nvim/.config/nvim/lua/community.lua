-- AstroCommunity: import any community modules here.
-- Imported in `lazy_setup.lua` before the `plugins/` folder, so these specs are
-- processed before (and can be overridden by) your own plugin specs.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  -- Language packs
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.python.base" },
  { import = "astrocommunity.pack.python.basedpyright" },
  { import = "astrocommunity.pack.python.ruff" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.prettier" },

  -- Markdown rendering inside Neovim
  { import = "astrocommunity.markdown-and-latex.render-markdown-nvim" },

  -- Bars and lines
  { import = "astrocommunity.bars-and-lines.dropbar-nvim" },

  -- Recipes
  { import = "astrocommunity.recipes.heirline-nvchad-statusline" },
  { import = "astrocommunity.recipes.auto-session-restore" },
  { import = "astrocommunity.recipes.vscode-icons" },

  -- Git
  { import = "astrocommunity.git.gitgraph-nvim" },

  -- Scrolling (disabled on phones in plugins/platform.lua)
  { import = "astrocommunity.scrolling.neoscroll-nvim" },

  -- <Leader>ut toggles transparent mode
  { import = "astrocommunity.color.transparent-nvim" },
}
