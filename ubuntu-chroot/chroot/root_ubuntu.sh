#!/system/bin/sh
# Run this via `su` in Termux to enter the chroot as the root user

CHROOT_DIR="/data/local/tmp/ubuntu-chroot"

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Please execute it using 'su'."
  exit 1
fi

echo "[*] Entering interactive terminal as root..."
chroot "$CHROOT_DIR" /usr/bin/env TERM=xterm-256color /bin/bash -l
