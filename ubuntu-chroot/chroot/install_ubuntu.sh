#!/system/bin/sh
# Run this via `su` in Termux

# Inject Termux's bin directory into the root path so it can find curl and GNU tar
export PATH="/data/data/com.termux/files/usr/bin:$PATH"

CHROOT_DIR="/data/local/tmp/ubuntu-chroot"
# Updated to the specific 24.04.4 point release
UBUNTU_URL="http://cdimage.ubuntu.com/ubuntu-base/releases/24.04/release/ubuntu-base-24.04.4-base-arm64.tar.gz"
TAR_FILE="/data/local/tmp/ubuntu-base.tar.gz"

echo "[*] Preparing the optimal extraction directory at $CHROOT_DIR..."
# Clean out any partial/broken extractions from the previous attempt
rm -rf "$CHROOT_DIR"
mkdir -p "$CHROOT_DIR"

echo "[*] Downloading Ubuntu 24.04.4 base image (ARM64)..."
# The -f flag forces curl to fail silently on server errors (like 404) instead of downloading an error page
if ! curl -f -L -o "$TAR_FILE" "$UBUNTU_URL"; then
  echo "[!] Download failed. The file was not found on the Ubuntu servers."
  exit 1
fi

echo "[*] Extracting base image. This might take a moment..."
if ! tar -xf "$TAR_FILE" -C "$CHROOT_DIR" --numeric-owner; then
  echo "[!] Extraction failed."
  rm -f "$TAR_FILE"
  exit 1
fi

echo "[*] Cleaning up archive..."
rm -f "$TAR_FILE"

echo "[*] Installation complete! You can now run the entry script."
