#!/bin/bash
set -e

# 1. Verify root execution
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

echo "Updating package lists and upgrading existing packages..."
apt-get update && apt-get upgrade -y

# 2. Install required system packages and build dependencies
echo "Installing sudo, curl, git, locales, and Python build dependencies..."
apt-get install -y sudo curl git locales build-essential \
    libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev ca-certificates

# 3. Configure Locales
echo "Configuring locales..."
locale-gen en_US.UTF-8 fr_FR.UTF-8
if command -v update-locale >/dev/null; then
    update-locale LANG=en_US.UTF-8
fi
export LANG=en_US.UTF-8

USERNAME="jkanangila"
PASSWORD="SecurePassword123!"

declare -A ANDROID_GROUPS=(
    ["aid_system"]=1000
    ["aid_radio"]=1001
    ["aid_graphics"]=1003
    ["aid_input"]=1004
    ["aid_audio"]=1005
    ["aid_camera"]=1006
    ["aid_log"]=1007
    ["aid_compass"]=1008
    ["aid_mount"]=1009
    ["aid_ext_data"]=1021
    ["aid_sdcard_rw"]=1015
    ["aid_media_rw"]=1023
    ["aid_bt"]=3001
    ["aid_bt_net"]=3002
    ["aid_inet"]=3003
    ["aid_net_raw"]=3004
    ["aid_admin"]=3005
)

echo "Initializing user provision for Android Chroot..."

# 2. Safely create Android System Groups mapping to exact Kernel AIDs
for group_name in "${!ANDROID_GROUPS[@]}"; do
    gid="${ANDROID_GROUPS[$group_name]}"
    if ! getent group "$group_name" >/dev/null; then
        echo "Mapping group: $group_name with GID: $gid"
        groupadd -g "$gid" "$group_name"
    else
        existing_gid=$(getent group "$group_name" | cut -d: -f3)
        if [ "$existing_gid" -ne "$gid" ]; then
            echo "Warning: Group $group_name exists but has GID $existing_gid (Expected $gid)"
        fi
    fi
done

# 3. Create the user
if ! id "$USERNAME" &>/dev/null; then
    echo "Creating user: $USERNAME"
    useradd -m -s /bin/bash "$USERNAME"
    echo "$USERNAME:$PASSWORD" | chpasswd
else
    echo "User $USERNAME already exists."
fi

# 4. Assign groups
for group_name in "${!ANDROID_GROUPS[@]}"; do
    usermod -aG "$group_name" "$USERNAME"
done

# 5. Fix home directory
USER_HOME=$(eval echo "~$USERNAME")
chmod 700 "$USER_HOME"
chown -R "$USERNAME:$USERNAME" "$USER_HOME"

# 6. Passwordless sudo (⚠️ Won’t work under nosuid chroot)
SUDOERS_FILE="/etc/sudoers.d/90-$USERNAME"
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >"$SUDOERS_FILE"
chmod 0440 "$SUDOERS_FILE"

echo "--------------------------------------------------------"
echo "Android Chroot User Setup Complete!"
echo "Target User   : $USERNAME"
echo "Home Path     : $USER_HOME"
echo "Sudo Access   : Configured (but may fail under nosuid)"
echo "Assigned AIDs : $(groups $USERNAME)"
echo "--------------------------------------------------------"
echo "CRITICAL: Update your password with: passwd $USERNAME"
