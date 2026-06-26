-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  -- import/override with your plugins folder
  { import = "astrocommunity.pack.lua" },
  -- PYTHON: Base pack with basedpyright and ruff
  { import = "astrocommunity.pack.python.base" },
  { import = "astrocommunity.pack.python.basedpyright" },
  { import = "astrocommunity.pack.python.ruff" },
  -- Bash
  { import = "astrocommunity.pack.bash" },
  -- Markdown Language Pack
  { import = "astrocommunity.pack.markdown" },
  -- TOML Language Pack
  { import = "astrocommunity.pack.toml" },
  -- Prettier
  { import = "astrocommunity.pack.prettier" },
  -- JSON Language Pack
  { import = "astrocommunity.pack.json" },
}
