--- Detects the current Operating System environment.
-- @return string os_type ("termux", "windows", "macos", "linux", "unknown")
local function detect_os()
    -- 1. Check for Termux
    local is_termux = os.execute("uname -o 2>/dev/null | grep -q Android") == 0 or os.getenv("TERMUX_VERSION") ~= nil
    if is_termux then
        return "termux"
    end

    -- 2. Check for Windows using Lua's path separator
    local is_windows = package.config:sub(1,1) == "\\"
    if is_windows then
        return "windows"
    end

    -- 3. Check macOS vs Linux via uname
    local handle = io.popen("uname -s")
    local uname = handle:read("*a"):match("^%s*(.-)%s*$")
    handle:close()
    
    if uname == "Darwin" then
        return "macos"
    elseif uname == "Linux" then
        return "linux"
    end

    return "unknown"
end

--- Determines the appropriate installation directory based on the OS type.
-- @param os_type string The detected OS type
-- @return string font_dir The path where fonts should be installed
local function get_font_directory(os_type)
    if os_type == "termux" then
        return os.getenv("HOME") .. "/.termux/"
    elseif os_type == "windows" then
        return os.getenv("LOCALAPPDATA") .. "\\Microsoft\\Windows\\Fonts\\"
    elseif os_type == "macos" then
        return os.getenv("HOME") .. "/Library/Fonts/"
    elseif os_type == "linux" then
        return os.getenv("HOME") .. "/.local/share/fonts/"
    else
        return ""
    end
end

--- Validates and automatically installs missing dependencies (curl, unzip) based on the OS.
-- @param os_type string The detected OS type
-- @return boolean true if dependencies are satisfied, false otherwise
local function handle_dependencies(os_type)
    print("Checking dependencies...")

    if os_type == "windows" then
        -- Windows uses native PowerShell features (Invoke-WebRequest / Expand-Archive)
        return true
    end

    -- Check for curl and unzip on Unix-like environments
    local has_curl = os.execute("command -v curl >/dev/null 2>&1") == 0
    local has_unzip = os.execute("command -v unzip >/dev/null 2>&1") == 0

    if has_curl and has_unzip then
        return true
    end

    print("Missing dependencies detected. Attempting automatic installation...")

    if os_type == "termux" then
        os.execute("pkg update -y && pkg install -y curl unzip")
    elseif os_type == "macos" then
        if os.execute("command -v brew >/dev/null 2>&1") == 0 then
            os.execute("brew install curl unzip")
        else
            print("Error: Homebrew is required to install missing dependencies on macOS.")
            return false
        end
    elseif os_type == "linux" then
        if os.execute("command -v apt-get >/dev/null 2>&1") == 0 then
            os.execute("sudo apt-get update && sudo apt-get install -y curl unzip")
        elseif os.execute("command -v dnf >/dev/null 2>&1") == 0 then
            os.execute("sudo dnf install -y curl unzip")
        elseif os.execute("command -v pacman >/dev/null 2>&1") == 0 then
            os.execute("sudo pacman -Sy --noconfirm curl unzip")
        else
            print("Error: Unsupported Linux distribution. Please install 'curl' and 'unzip' manually.")
            return false
        end
    end

    -- Re-verify packages
    has_curl = os.execute("command -v curl >/dev/null 2>&1") == 0
    has_unzip = os.execute("command -v unzip >/dev/null 2>&1") == 0

    return has_curl and has_unzip
end

--- Main function to install a Nerd Font
-- @param font_name string? The name of the font (default: "FiraCode")
local function install_nerd_font(font_name)
    font_name = font_name or "FiraCode"
    
    -- 1. Identify Environment & Paths
    local os_type = detect_os()
    local font_dir = get_font_directory(os_type)
    
    print("Detected Environment: " .. os_type)
    print("Target Directory: " .. font_dir)

    if os_type == "unknown" or font_dir == "" then
        print("Error: Unsupported or unknown OS environment. Aborting.")
        return
    end

    -- 2. Resolve Dependencies
    if not handle_dependencies(os_type) then
        print("Error: Could not resolve required dependencies (curl, unzip). Aborting.")
        return
    end

    -- 3. Create Font Directory
    if os_type == "windows" then
        os.execute('mkdir "' .. font_dir .. '" 2>nul')
    else
        os.execute('mkdir -p "' .. font_dir .. '"')
    end

    -- 4. Download and Install
    local download_url = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/" .. font_name .. ".zip"
    print("Downloading " .. font_name .. " Nerd Font...")

    if os_type == "windows" then
        local zip_path = os.getenv("TEMP") .. "\\" .. font_name .. ".zip"
        local download_cmd = string.format('powershell -Command "Invoke-WebRequest -Uri \'%s\' -OutFile \'%s\'"', download_url, zip_path)
        local extract_cmd = string.format('powershell -Command "Expand-Archive -Path \'%s\' -DestinationPath \'%s\' -Force"', zip_path, font_dir)
        
        if os.execute(download_cmd) == 0 and os.execute(extract_cmd) == 0 then
            print("Font files extracted. Note: You may need to double-click a .ttf file to register it system-wide on Windows.")
        else
            print("Error: Extraction failed on Windows.")
        end
    elseif os_type == "termux" then
        local temp_dir = "/tmp/nerdfont_" .. font_name
        os.execute("mkdir -p " .. temp_dir)
        
        local cmd = string.format("curl -fLo %s/%s.zip %s && unzip -o %s/%s.zip -d %s", temp_dir, font_name, download_url, temp_dir, font_name, temp_dir)
        
        if os.execute(cmd) == 0 then
            local move_cmd = string.format("cp $(find %s -name '*Regular.ttf' -o -name '*Medium.ttf' -o -name '*.ttf' | head -n 1) %s/font.ttf", temp_dir, font_dir)
            os.execute(move_cmd)
            os.execute("termux-reload-settings")
            print("Successfully installed and updated Termux font styles!")
        else
            print("Error: Download/Extraction failed in Termux.")
        end
        os.execute("rm -rf " .. temp_dir)
    else
        -- Standard Linux / macOS execution
        local temp_zip = "/tmp/" .. font_name .. ".zip"
        local cmd = string.format("curl -fLo %s %s && unzip -o %s -d %s", temp_zip, download_url, temp_zip, font_dir)
        
        if os.execute(cmd) == 0 then
            if os_type == "linux" then
                os.execute("fc-cache -fv " .. font_dir .. " > /dev/null")
            end
            print("Successfully installed " .. font_name .. " Nerd Font!")
        else
            print("Error: Download/Extraction failed.")
        end
        os.remove(temp_zip)
    end
end

-- Run installation
install_nerd_font("FiraCode")
