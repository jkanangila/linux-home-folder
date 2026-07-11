#!/system/bin/sh

CHROOT_DIR="/data/local/tmp/ubuntu-chroot"

echo -e "\n[*] Cleaning up and safely unmounting filesystems..."
for mp in sdcard dev/pts dev/shm dev sys proc; do
  busybox umount "$CHROOT_DIR/$mp" 2>/dev/null || true
done

