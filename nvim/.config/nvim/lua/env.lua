
--- Detects the current operating system and the specific hardware/runtime environment.
--- @return string os The detected operating system ("linux", "windows", "macos", or "unknown").
--- @return string device The specific runtime environment ("wsl", "termux", "android_chroot", "desktop", or "unknown").
local function get_environment_info()
    local detected_os = "unknown"
    local detected_device = "unknown"

    local path_separator = package.config:sub(1,1)
    if path_separator == "/" then
        detected_os = "linux"
        -- Quick check for macOS using vim internal helper instead of io.popen
        if vim.fn.has("mac") == 1 or vim.fn.has("macunix") == 1 then
            detected_os = "macos"
        end
    elseif path_separator == "\\" then
        detected_os = "windows"
        return detected_os, "desktop"
    end

    if detected_os == "linux" or detected_os == "macos" then
        detected_device = "desktop"
        
        local prefix = os.getenv("PREFIX")
        if prefix and string.find(prefix, "com.termux") then
            return "linux", "termux"
        end

        local android_root = os.getenv("ANDROID_ROOT")
        local android_data = os.getenv("ANDROID_DATA")
        local path_env = os.getenv("PATH") or ""
        if android_root or android_data or string.find(path_env, "com.termux") then
            return "linux", "android_chroot"
        end

        local version_file = io.open("/proc/version", "r")
        if version_file then
            local version_info = version_file:read("*all"):lower()
            version_file:close()
            if string.find(version_info, "microsoft") or string.find(version_info, "wsl") then
                return "linux", "wsl"
            end
        end
    end

    return detected_os, detected_device
end

local os_type, device_type = get_environment_info()

return {
    os = os_type,
    device = device_type,
    is_wsl = device_type == "wsl",
    is_termux = device_type == "termux",
    is_chroot = device_type == "android_chroot",
}
