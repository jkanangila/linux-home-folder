-- Helper function to fetch the dynamic WSL host IP
local function get_wsl_host_ip()
  -- Executes your shell pipeline and captures standard output
  local handle = vim.fn.system "ip route show | grep -i default | awk '{ print $3}'"
  -- Trim off trailing newlines
  local ip = vim.trim(handle)

  -- Fall back to localhost if the command returns empty (e.g. non-WSL environment)
  if ip == "" then return "127.0.0.1" end
  return ip
end

local ip = get_wsl_host_ip()

return { host_ip = ip }
