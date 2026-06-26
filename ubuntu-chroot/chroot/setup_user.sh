
#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

USERNAME="jkanangila"

# 1. Verify root execution
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

echo "Updating package lists and upgrading existing packages..."
apt-get update && apt-get upgrade -y

# 2. Install required system packages and build dependencies
# These dependencies are strictly required for Pyenv to compile Python from source successfully.
echo "Installing sudo, curl, git, locales, and Python build dependencies..."
apt-get install -y sudo curl git locales build-essential \
    libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev ca-certificates

# 3. Configure Locales
# Generating standard English for dev stability, and French as an available option.
echo "Configuring locales..."
locale-gen en_US.UTF-8
locale-gen fr_FR.UTF-8
update-locale LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# 4. Create the new user
echo "Creating user: $USERNAME..."
if id "$USERNAME" &>/dev/null; then
    echo "User $USERNAME already exists."
else
    # -m creates the home directory, -s sets the default shell to bash
    useradd -m -s /bin/bash "$USERNAME"
fi

# 5. Grant administrative privileges & passwordless sudo
echo "Configuring passwordless sudo for $USERNAME..."
usermod -aG sudo "$USERNAME"
echo "$USERNAME ALL=(ALL:ALL) NOPASSWD: ALL" > "/etc/sudoers.d/$USERNAME"
chmod 0440 "/etc/sudoers.d/$USERNAME"

# 6. Install NVM (Node Version Manager)
echo "Installing NVM for user $USERNAME..."
# We use 'su -c' to ensure NVM is installed directly into the user's home directory
su - "$USERNAME" -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash"

# 7. Install Pyenv
echo "Installing Pyenv for user $USERNAME..."
su - "$USERNAME" -c "curl https://pyenv.run | bash"

# 8. Configure .bashrc for Pyenv
# NVM automatically appends its configuration to .bashrc, but Pyenv needs manual setup.
echo "Configuring Pyenv environment variables..."
cat << 'EOF' >> "/home/$USERNAME/.bashrc"

# Pyenv Configuration
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
EOF

# Ensure all files in the home directory are owned by the user
chown -R "$USERNAME:$USERNAME" "/home/$USERNAME"

echo "==================================================="
echo "Setup is complete!"
echo "Switch to your new user by running: su - $USERNAME"
echo "==================================================="
