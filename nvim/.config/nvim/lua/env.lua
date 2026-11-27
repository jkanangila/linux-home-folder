--- Environment detection shared by every config file.
--- Computed once at require time; no shell-outs, so it is free at startup.
---
--- Devices: "termux", "android_chroot", "wsl", "desktop" (CachyOS, Ubuntu, any other Linux/macOS).
local uv = vim.uv or vim.loop

---@return string os, string device
local function detect()
  if vim.fn.has "win32" == 1 then return "windows", "desktop" end

  local os_name = vim.fn.has "mac" == 1 and "macos" or "linux"

  -- Termux: PREFIX points into com.termux *and* that directory is really visible.
  -- A chroot started from Termux can inherit PREFIX without having the directory,
  -- which used to be misdetected as Termux.
  local prefix = vim.env.PREFIX or ""
  if prefix:find("com.termux", 1, true) and uv.fs_stat(prefix) then return os_name, "termux" end

  local release = (uv.os_uname().release or ""):lower()

  if vim.fn.has "wsl" == 1 or release:find("microsoft", 1, true) then return os_name, "wsl" end

  if
    vim.env.ANDROID_ROOT
    or vim.env.ANDROID_DATA
    or release:find("android", 1, true)
    or (vim.env.PATH or ""):find("com.termux", 1, true)
  then
    return os_name, "android_chroot"
  end

  return os_name, "desktop"
end

local os_type, device_type = detect()

-- Terminals that implement the kitty graphics protocol (needed by image.nvim).
local term_program = vim.env.TERM_PROGRAM or ""
local has_graphics = vim.env.KITTY_WINDOW_ID ~= nil
  or vim.env.TERM == "xterm-kitty"
  or vim.env.GHOSTTY_RESOURCES_DIR ~= nil
  or term_program == "ghostty"
  or term_program == "WezTerm"

local M = {
  os = os_type,
  device = device_type,
  is_wsl = device_type == "wsl",
  is_termux = device_type == "termux",
  is_chroot = device_type == "android_chroot",
  has_graphics = has_graphics,
}

--- Phone/tablet environments: little CPU, no glibc Mason binaries (Termux), low inotify limits.
M.is_mobile = M.is_termux or M.is_chroot

--- Windows host IP as seen from WSL2 (NAT mode). Lazy on purpose: only runs when called.
---@return string
function M.wsl_host_ip()
  if not M.is_wsl or vim.fn.executable "ip" ~= 1 then return "127.0.0.1" end
  local res = vim.system({ "ip", "route", "show", "default" }, { text = true }):wait()
  return (res.stdout or ""):match "via%s+(%S+)" or "127.0.0.1"
end

return M
