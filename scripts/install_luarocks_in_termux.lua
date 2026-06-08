
local function install_luarocks_in_termux()
    print("Updating packages and installing luarocks...")
    -- Executes the Termux package manager commands
    local requirements = os.execute("pkg update && pkg upgrade -y")
    
    if requirements then
        local success = os.execute("pkg install clang make binutils lua51 luarocks -y")
        
        if success then
            print("Luarocks installed successfully!")
        else
            print("Installation failed. Please check your internet connection or Termux repositories.")
        end
    else
        print("Installation failed. Please check your internet connection or Termux repositories.")
    end
end

-- Call the function
install_luarocks_in_termux()
