
-- Automates the installation of the 'bottom' (btm) system monitor in Termux.
-- @param version (optional string): The specific version tag to download (e.g., "0.10.2").
function install_bottom_for_termux(version)
    -- Fallback to a default stable version if no argument is provided
    version = version or "0.10.3"

    print("[*] Updating Termux packages...")
    os.execute("pkg update && pkg upgrade -y")

    print("[*] Installing required dependencies (curl, tar)...")
    os.execute("pkg install curl tar -y")

    -- Static configuration targeting standard 64-bit Termux2
    -- 
    local tar_file = "bottom_aarch64-linux-android.tar.gz"
    local download_url = string.format("https://github.com/ClementTsang/bottom/releases/download/%s/bottom_aarch64-linux-android.tar.gz", version)

    print("[*] Downloading bottom v" .. version .. "...")
    local download_success = os.execute("curl -LO " .. download_url)

    if not download_success then
        print("[-] Download failed. Check your internet connection or version string.")
        return false
    end

    print("[*] Extracting package...")
    os.execute("tar -xvzf " .. tar_file)

    print("[*] Moving 'btm' binary to Termux $PREFIX/bin...")
    os.execute("chmod +x btm")
    os.execute("mv btm $PREFIX/bin/")

    print("[*] Cleaning up temporary download files...")
    os.execute("rm " .. tar_file)

    print("[+] Success! Type 'btm' in your Termux terminal to run it.")
    return true
