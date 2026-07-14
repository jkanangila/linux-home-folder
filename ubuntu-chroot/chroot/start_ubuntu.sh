#!/system/bin/sh
# Run this via `su` in Termux

CHROOT_DIR="/data/local/tmp/ubuntu-chroot"
USER_NAME="jkanangila"

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Please execute it using 'su'."
  exit 1
fi

cleanup() {
  echo "Stopping clipboard sync..."
  pkill -f "ubuntu_clip_sync.sh"
  pkill -f "ncat.*8378"
  pkill -x "Xvfb"

  echo -e "\n[*] Cleaning up and safely unmounting filesystems..."
  for mp in sdcard dev/pts dev/shm dev sys proc; do
    busybox umount -l "$CHROOT_DIR/$mp" 2>/dev/null || true
  done
  echo "[*] Exited chroot cleanly."
}

# Trap ensures unmounting happens on normal exit, interrupts (Ctrl+C), or termination
trap cleanup EXIT HUP INT TERM

# Fix setuid issue
busybox mount -o remount,dev,suid /data

echo "[*] Mounting essential system directories..."

# Helper function to check mounts before running them
safe_mount() {
  target_path="$CHROOT_DIR/$1"
  # Clean up path string trailing slashes for an exact match in /proc/mounts
  match_path=$(echo "$target_path" | sed 's/\/$//')
  
  if grep -qF " $match_path " /proc/mounts; then
    return 0 # Already mounted, skip silently
  else
    shift # Drop the path argument, pass the remaining parameters directly to mount
    busybox mount "$@" "$target_path" 2>/dev/null
  fi
}

safe_mount "proc" -t proc proc
safe_mount "sys" -t sysfs sysfs
safe_mount "dev" -o bind /dev
safe_mount "dev/pts" -o bind /dev/pts

# Android specifically requires a tmpfs for shared memory
mkdir -p "$CHROOT_DIR/dev/shm"
safe_mount "dev/shm" -t tmpfs -o size=256M tmpfs

# Bind Android's internal storage
mkdir -p "$CHROOT_DIR/sdcard"
if ! grep -qF " $CHROOT_DIR/sdcard " /proc/mounts; then
  mount -o bind /storage/emulated/0 "$CHROOT_DIR/sdcard" 2>/dev/null || mount -o bind /sdcard "$CHROOT_DIR/sdcard" 2>/dev/null
fi

# Force DNS resolution mapping
echo "nameserver 8.8.8.8" >"$CHROOT_DIR/etc/resolv.conf"
echo "nameserver 1.1.1.1" >>"$CHROOT_DIR/etc/resolv.conf"
echo "127.0.0.1 localhost" >"$CHROOT_DIR/etc/hosts"

# First-time initialization routine injected directly into the chroot
if [ ! -f "$CHROOT_DIR/root/.setup_done" ]; then
  echo "[*] First run detected. Configuring environment, groups, and packages..."

  cat <<EOF >"$CHROOT_DIR/tmp/init_setup.sh"
#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export DEBIAN_FRONTEND=noninteractive

echo "[*] Updating apt repositories..."
apt-get update -y

echo "[*] Installing core utilities and scripting tools..."
apt-get install -y sudo locales apt-utils tzdata curl wget git build-essential \
    tmux python3 python3-venv lua5.4 neovim

echo "[*] Configuring locales and local timezone settings..."
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8
ln -fs /usr/share/zoneinfo/Africa/Kinshasa /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

echo "[*] Creating Android-specific groups for networking and storage..."
groupadd -g 3003 inet
groupadd -g 3004 net_raw
groupadd -g 1015 sdcard_rw
groupadd -g 9997 everybody

echo "[*] Setting up default user: $USER_NAME"
useradd -m -G sudo,inet,net_raw,sdcard_rw,everybody -s /bin/bash "$USER_NAME"

echo "[*] Configuring passwordless sudo..."
echo "$USER_NAME ALL=(ALL:ALL) NOPASSWD: ALL" > "/etc/sudoers.d/$USER_NAME"
chmod 0440 "/etc/sudoers.d/$USER_NAME"

touch /root/.setup_done
echo "[*] Initial setup complete!"
EOF

  chmod +x "$CHROOT_DIR/tmp/init_setup.sh"
  chroot "$CHROOT_DIR" /bin/bash /tmp/init_setup.sh
  rm -f "$CHROOT_DIR/tmp/init_setup.sh"
fi

echo "[*] Entering interactive terminal as $USER_NAME..."
exec script -q -c "chroot \"$CHROOT_DIR\" /bin/login -f \"$USER_NAME\"" /dev/null
