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

    -- 2. Install Go and Git compilers
    print("[*] Installing Go and Git...")
    local deps_status = os.execute("pkg install golang git -y")
    if not deps_status then
        print("[-] Error: Failed to install Golang or Git.")
        return false
    end

    -- 3. Download and build gdu via Go
    print("[*] Downloading and compiling gdu via Go...")
    local build_status = os.execute("go install github.com/dundee/gdu/v5/cmd/gdu@latest")
    if not build_status then
        print("[-] Error: Failed to compile gdu.")
        return false
    end

    -- 4. Update the PATH variable within the current shell context
    -- Note: This injects the Go binary path for immediate use and future sessions
    print("[*] Configuring environment PATH...")
    os.execute("echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.zshrc")
    
    -- 5. Request Android storage permissions for Termux
    print("[*] Requesting Android storage setup (Accept the prompt if it appears)...")
    os.execute("termux-setup-storage")

    print("[+] gdu successfully installed for Termux!")
    print("[+] Restart your Termux app or run 'source ~/.bashrc' to begin using gdu.")
    return true
end

-- Example execution:
-- install_gdu_in_termux()

