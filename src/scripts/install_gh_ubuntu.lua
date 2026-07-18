#!/usr/bin/env lua

-- Colors for output styling
local green = "\27[32m"
local red = "\27[31m"
local yellow = "\27[33m"
local reset = "\27[0m"

local function log_info(msg)
	print(green .. "[INFO] " .. reset .. msg)
end
local function log_warn(msg)
	print(yellow .. "[WARN] " .. reset .. msg)
end
local function log_error(msg)
	print(red .. "[ERROR] " .. reset .. msg)
end

-- Step runner helper that exits if a command fails
local function run_cmd(cmd, step_name)
	log_info("Running: " .. step_name .. "...")
	local success = os.execute(cmd)
	if not success then
		log_error("Failed during: " .. step_name)
		os.exit(1)
	end
end

-- 1. Check if gh CLI is already installed
local check_gh = os.execute("command -v gh > /dev/null 2>&1")
if check_gh then
	log_warn("GitHub CLI (gh) is already installed on this system.")
	os.execute("gh --version")
	os.exit(0)
end

print(yellow .. "=== Starting GitHub CLI Installation ===" .. reset)
print("Note: This script requires sudo privileges to install packages.\n")

-- 2. Execute installation sequence
run_cmd("sudo mkdir -p -m 755 /etc/apt/keyrings", "Creating keyrings directory")

run_cmd(
	"wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null",
	"Downloading official GitHub GPG key"
)

run_cmd("sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg", "Setting GPG key permissions")

-- Constructing the echo string cleanly to avoid string interpolation complexity inside os.execute
local repo_cmd =
	'echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null'
run_cmd(repo_cmd, "Adding GitHub CLI repository to sources")

run_cmd("sudo apt update", "Updating apt package lists")

run_cmd("sudo apt install gh -y", "Installing GitHub CLI package")

-- 3. Verification
print("\n" .. green .. "=== Installation Complete! ===" .. reset)
os.execute("gh --version")
print("\nYou can now run " .. yellow .. "gh auth login" .. reset .. " to authenticate.")
