
local function install_lazygit_in_termux()
    print("Updating packages and installing lazygit...")
    -- Executes the Termux package manager commands
    local success = os.execute("pkg update && pkg upgrade -y && pkg install git lazygit -y")
    
    if success then
        print("lazygit installed successfully!")
    else
        print("Installation failed. Please check your internet connection or Termux repositories.")
    end
end

-- Call the function
install_lazygit_in_termux()
