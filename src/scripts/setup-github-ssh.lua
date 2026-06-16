
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
        print("\27[31mError: Public key file missing. Cannot display instructions.\27[0m")
        return
    end

    -- Trim trailing whitespace and newlines cleanly
    pub_key_text = string.gsub(pub_key_text, "%s+$", "")

    -- Visual framing layouts
    local width = 75
    local border = string.rep("=", width)
    local divider = string.rep("-", width)

    -- Formatting helper for titles
    local function print_header(title)
        local pad = math.floor((width - #title) / 2)
        print(string.rep("-", pad) .. " " .. title .. " " .. string.rep("-", width - pad - #title - 2))
    end

    print("\n" .. border)
    print(string.format("%s", " SSH SETUP SUCCESSFUL — FINAL STEPS REQUIRED "):gsub("^%s*(.-)%s*$", function(c) 
        local pad = math.floor((width - #c) / 2)
        return string.rep(" ", pad) .. c .. string.rep(" ", pad)
    end))
    print(border .. "\n")

    print_header("1. ADD KEY TO GITHUB")
    print("  A. Copy your public key block below (highlight everything in green):")
    print("\n\27[32m" .. pub_key_text .. "\27[0m\n")
    print("  B. Open this URL in your browser:")
    print("     \27[36mhttps://github.com/settings/ssh/new\27[0m")
    print("  C. Give it a meaningful 'Title' (e.g., 'Work Laptop - Ubuntu')")
    print("  D. Keep the Key type as 'Authentication Key'")
    print("  E. Paste the green text into the 'Key' field and click 'Add SSH Key'")
    print("\n" .. divider)

    print_header("2. VERIFY YOUR CONNECTION")
    print("  Once added, test that it works by running this in your terminal:")
    print("\n     \27[33mssh -T git@github.com\27[0m\n")
    print("  * You should see: 'Hi " .. email:match("([^@]+)") .. "! You've successfully authenticated...'")
    print("  * If asked to continue connecting (yes/no), type \27[1myes\27[0m and press Enter.")
    print("\n" .. divider)

    print_header("3. UPDATE EXISTING LOCAL REPOSITORIES TO USE SSH")
    print("  If you have existing projects currently cloned via HTTPS, they will still")
    print("  ask for a password/token. Run these commands inside those project folders:")
    print("\n  A. Check your current remote URL:")
    print("     \27[33mgit remote -v\27[0m")
    print("     (If it starts with 'https://github.com/...', it needs updating)")
    print("\n  B. Switch the remote URL from HTTPS to SSH:")
    print("     \27[33mgit remote set-url origin git@github.com:USERNAME/REPOSITORY.git\27[0m")
    print("     *(Replace USERNAME/REPOSITORY with your actual GitHub project path)*")
    print("\n  C. Verify the change was successful:")
    print("     \27[33mgit remote -v\27[0m")
    print("     (It should now read: git@github.com:...)")
    print("\n" .. divider)

    print_header("4. RECOMMENDED GLOBAL GIT CONFIGURATION")
    print("  Ensure your local git commits point cleanly to this email address:")
    print(string.format("\n     git config --global user.email \"%s\"", email))
    print("     git config --global user.name \"Your Name\"\n")
    print(border .. "\n")
end


-- ----------------------------------- MAIN ----------------------------------- --
setup_ssh_directory()
generate_ssh_key()
update_ssh_config()
add_key_to_agent()
display_instructions()
