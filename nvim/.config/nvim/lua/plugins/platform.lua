-- Per-device overrides in ONE place. Everything else in this config is device-agnostic.
-- Device flags come from lua/env.lua (wsl / termux / android chroot / desktop).
local env = require "env"

---@type LazySpec
return {
  -- Smooth-scroll animations are laggy on phone terminals.
  { "karb94/neoscroll.nvim", enabled = not env.is_mobile },
}
