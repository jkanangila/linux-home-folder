--- Automates the installation of the latest Pipenv on Ubuntu (Linux, WSL, or Termux chroot)
-- @return boolean Success status
-- @return string Error message or success summary
local function install_latest_pipenv()
  print("[*] Beginning Pipenv installation sequence...")

  -- 1. Update package indices and ensure system prerequisites are present
  -- 'python3-venv' is strictly required to bypass PEP 668 managed environment blocks.
  print("[*] Synchronizing apt package manager registries and installing dependencies...")
  local apt_cmd = "sudo apt-get update && sudo apt-get install -y python3 python3-pip python3-venv"
  local apt_status = os.execute(apt_cmd)

  if not apt_status then
    return false, "Failed to install system dependencies via apt package manager."
  end

  -- 2. Build local safe paths for isolation
  local home = os.getenv("HOME")
  if not home then
    return false, "Unable to resolve the environment variable: $HOME"
  end

  local bin_dir = home .. "/.local/bin"
  local venv_dir = home .. "/.local/pipenv-venv"

  -- 3. Create the local binary layout path if missing
  os.execute("mkdir -p " .. bin_dir)

  -- 4. Clean up any existing broken installation directory
  os.execute("rm -rf " .. venv_dir)

  -- 5. Spin up an isolated Python Virtual Environment
  print("[*] Initializing an isolated Python environment at: " .. venv_dir)
  local venv_status = os.execute("python3 -m venv " .. venv_dir)
  if not venv_status then
    return false, "Failed to construct isolated Python environment via 'python3 -m venv'."
  end

  -- 6. Perform the pip upgrades internally
  print("[*] Downloading and deploying the latest version of Pipenv from PyPI...")
  local install_cmd =
      string.format("%s/bin/pip install --upgrade pip setuptools && %s/bin/pip install pipenv", venv_dir, venv_dir)
  local pip_status = os.execute(install_cmd)
  if not pip_status then
    return false, "Failed to fetch and install pipenv inside the isolated environment."
  end

  -- 7. Symlink the pipenv binary to a user-level directory managed by PATH
  local symlink_src = venv_dir .. "/bin/pipenv"
  local symlink_dst = bin_dir .. "/pipenv"

  -- Force-remove any stale symlink or blocking file before execution
  os.execute("rm -f " .. symlink_dst)

  print("[*] Exposing binary to execution layer via user symlink...")
  local link_status = os.execute(string.format("ln -s %s %s", symlink_src, symlink_dst))
  if not link_status then
    return false, "Could not map symlink target to " .. symlink_dst
  end

  -- 8. Verify shell capability
  print("[*] Running execution sanity check...")
  local check_status = os.execute(symlink_dst .. " --version")
  if not check_status then
    return false, "Pipenv binary mapped successfully but failed execution run check."
  end

  -- 9. Remind user to update path if needed
  local shell_reminder = "\n[✔] Success! Ensure '"
      .. bin_dir
      .. "' is appended to your shell's $PATH variable.\n"
      .. "    Example: echo 'export PATH=\"$HOME/.local/bin:$PATH\"' >> ~/.bashrc"

  return true, shell_reminder
end

-- Execution Block Example
local _, result = install_latest_pipenv()
print(result)
