
-- --------------------------------- Settings --------------------------------- --
local email = "jkanangila@gmail.com"
local home = os.getenv("HOME")
local ssh_dir = home .. "/.ssh"
local private_key = ssh_dir .. "/id_ed25519"
local public_key = ssh_dir .. "/id_ed25519.pub"
local config_file = ssh_dir .. "/config"

local config_marker = "# --- Managed by Automation for GitHub ---"
local config_block = string.format([[
%s
Host github.com
    AddKeysToAgent yes
    IdentityFile %s
]], config_marker, private_key)

-- ----------------------------- Helper Functions ---------------------------- --

-- Robust file existence check
local function file_exists(path)
    local f = io.open(path, "r")
    if f then f:close() return true end
    return false
end

-- Safely read file contents
local function read_file(path)
    local f = io.open(path, "r")
    if not f then return "" end
    local content = f:read("*a")
    f:close()
    return content
end

-- --------------------------------- Functions -------------------------------- --

local function setup_ssh_directory()
    -- Create directory if it doesn't exist and force strict 700 permissions
    if not file_exists(ssh_dir) then
        print("Creating " .. ssh_dir .. "...")
        os.execute("mkdir -p " .. ssh_dir)
    end
    os.execute("chmod 700 " .. ssh_dir)
end

local function generate_ssh_key()
    if file_exists(private_key) then
        print("✓ SSH Key already exists. Skipping generation.")
        return
    end

    print("Generating a new Ed25519 SSH key...")
    local cmd = string.format('ssh-keygen -t ed25519 -C "%s" -N "" -f "%s"', email, private_key)
    local success = os.execute(cmd)
    
    if success then
        os.execute("chmod 600 " .. private_key)
    else
        print("Error: Failed to generate SSH key.")
        os.exit(1)
    end
end

local function update_ssh_config()
    local content = read_file(config_file)

    -- IDEMPOTENCY CHECK: Avoid duplicating configuration text
    if string.find(content, config_marker, 1, true) then
        print("✓ SSH Config already contains settings. Skipping update.")
        return
    end

    print("Updating SSH configuration...")
    
    -- Open in append mode (a+), creating it if it doesn't exist
    local f = io.open(config_file, "a+")
    if f then
        -- Add a leading newline if the existing file doesn't end cleanly
        if #content > 0 and string.sub(content, -1, -1) ~= "\n" then
            f:write("\n")
        end
        f:write(config_block)
        f:close()
        
        -- SSH config must have strict 600 permissions or SSH commands will fail
        os.execute("chmod 600 " .. config_file)
    else
        print("Error: Could not write to " .. config_file)
    end
end

local function add_key_to_agent()
    print("Adding key to ssh-agent...")
    
    -- Check if an agent is actually running in the active user environment
    if not os.getenv("SSH_AUTH_SOCK") then
        print("! Warning: No active ssh-agent detected in environment.")
        print("  You may need to run 'eval $(ssh-agent -s)' manually.")
        return
    end

    local success = os.execute(string.format('ssh-add "%s" 2>/dev/null', private_key))
    if success then
        print("✓ Key successfully added to ssh-agent.")
    else
        print("! Failed to automatically add key to agent.")
    end
end

local function display_instructions()
    local pub_key_text = read_file(public_key)
    if pub_key_text == "" then
        print("Error: Public key missing.")
        return
    end

    -- Trim trailing whitespace and newlines
    pub_key_text = string.gsub(pub_key_text, "%s+$", "")

    print("\n" .. string.rep("=", 60))
    print(string.format("%s", " SETUP COMPLETE — NEXT STEPS "):gsub("^%s*(.-)%s*$", function(c) 
        local pad = math.floor((60 - #c) / 2)
        return string.rep("-", pad) .. c .. string.rep("-", pad)
    end))
    print(string.rep("=", 60))
    
    -- Uses standard ANSI codes for green text output for the key block
    print("\n1. Copy your public key below:\n")
    print("\27[32m" .. pub_key_text .. "\27[0m")
    print("\n2. Open this link in your browser:")
    print("   https://github.com/settings/ssh/new")
    print("\n3. Paste the key, give it a Title, and save.")
    print(string.rep("=", 60) .. "\n")
end

-- ----------------------------------- MAIN ----------------------------------- --
setup_ssh_directory()
generate_ssh_key()
update_ssh_config()
add_key_to_agent()
display_instructions()
