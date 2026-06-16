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

return detect_os