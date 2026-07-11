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
  echo -e "\n[*] Cleaning up and safely unmounting filesystems..."
  for mp in sdcard dev/pts dev/shm dev sys proc; do
    umount "$CHROOT_DIR/$mp" 2>/dev/null || true
  done
  echo "[*] Exited chroot cleanly."
}

# Trap ensures unmounting happens on normal exit, interrupts (Ctrl+C), or termination
trap cleanup EXIT HUP INT TERM

# Fix setuid issue
busybox mount -o remount,dev,suid /data

echo "[*] Mounting essential system directories..."
mount -t proc proc "$CHROOT_DIR/proc"
mount -t sysfs sysfs "$CHROOT_DIR/sys"
mount -o bind /dev "$CHROOT_DIR/dev"

# BIND-MOUNT host's existing devpts so Termux's TTYs are passed directly to the chroot
mount -o bind /dev/pts "$CHROOT_DIR/dev/pts"

# Android specifically requires a tmpfs for shared memory; otherwise, databases and multiprocess apps crash
mkdir -p "$CHROOT_DIR/dev/shm"
mount -t tmpfs -o size=256M tmpfs "$CHROOT_DIR/dev/shm"

# Bind Android's internal storage for easy file transfer between Termux and the chroot
mkdir -p "$CHROOT_DIR/sdcard"
mount -o bind /storage/emulated/0 "$CHROOT_DIR/sdcard" 2>/dev/null || mount -o bind /sdcard "$CHROOT_DIR/sdcard" 2>/dev/null

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
# Drop the -c flag and use standard execution so su handles the login shell and preserves job control
chroot "$CHROOT_DIR" /usr/bin/env TERM=xterm-256color /bin/su - "$USER_NAME"
