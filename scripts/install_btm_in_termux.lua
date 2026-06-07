
function install_btm_in_termux()
    -- Run the package update and installation commands
    local success = os.execute("pkg update && pkg upgrade -y && pkg install btm -y")
    
    -- Check if the command executed successfully
    if success then
        print("Success: btm has been installed successfully!")
        return true
    else
        print("Error: Failed to install btm. Please check your Termux network connection.")
        return false
    end
end

-- Call the function
install_btm_in_termux()
