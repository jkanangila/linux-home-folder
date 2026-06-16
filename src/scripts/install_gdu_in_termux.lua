
-- Function to install gdu (Go Disk Usage) specifically inside Termux
function install_gdu_in_termux()
    print("[*] Starting gdu installation for Termux...")

    -- 1. Update Termux repositories and packages
    print("[*] Updating and upgrading Termux packages...")
    local update_status = os.execute("pkg update && pkg upgrade -y")
    if not update_status then
        print("[-] Error: Failed to update Termux packages.")
        return false
    end

    -- 2. Install gdu natively via the Termux package manager
    print("[*] Installing gdu...")
    local install_status = os.execute("pkg install gdu -y")
    if not install_status then
        print("[-] Error: Failed to install gdu.")
        return false
    end
    
    -- 3. Request Android storage permissions for Termux
    print("[*] Requesting Android storage setup (Accept the prompt if it appears)...")
    os.execute("termux-setup-storage")

    print("[+] gdu successfully installed for Termux!")
    print("[+] It is ready to use immediately.")
    return true
end

-- Example execution:
install_gdu_in_termux()
