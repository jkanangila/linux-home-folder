#!/bin/bash

# Configuration
CHROOT_DIR="/data/data/com.termux/files/home/chroot/ubuntu"
# Dedicated folder for your backups
BACKUP_DIR="/data/data/com.termux/files/home/chroot_backups"

# Create the dedicated backup directory if it does not exist
mkdir -p "$BACKUP_DIR"

# Generate file name with current timestamp (Format: YYYYMMDD-HHMMSS)
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
ARCHIVE_NAME="ubuntu-backup-$TIMESTAMP.tar.bz2"
BACKUP_PATH="$BACKUP_DIR/$ARCHIVE_NAME"

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run this script with sudo or as root."
  exit 1
fi

# Ensure chroot directory exists
if [ ! -d "$CHROOT_DIR" ]; then
  echo "Error: Chroot directory $CHROOT_DIR does not exist."
  exit 1
fi

case "$1" in
backup)
  echo "Starting backup of $CHROOT_DIR..."
  tar --one-file-system -cvpjf "$BACKUP_PATH" -C "$CHROOT_DIR" .
  echo "Backup completed successfully at $BACKUP_PATH"
  ;;

restore)
  # List available backups so the user can choose which historical version to restore
  echo "Available historical backups:"
  echo "----------------------------"
  ls -1 "$BACKUP_DIR"/ubuntu-backup-*.tar.bz2 2>/dev/null
  echo "----------------------------"

  read -p "Enter the full path of the backup file you want to restore: " SELECTED_BACKUP

  if [ ! -f "$SELECTED_BACKUP" ]; then
    echo "Error: File '$SELECTED_BACKUP' does not exist."
    exit 1
  fi

  echo "Warning: This will overwrite files in $CHROOT_DIR."
  read -p "Are you sure you want to proceed? (y/N): " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Restore aborted."
    exit 0
  fi

  echo "Starting restore using $SELECTED_BACKUP..."
  tar -xvpejf "$SELECTED_BACKUP" -C "$CHROOT_DIR"
  echo "Restore completed successfully."
  ;;

*)
  echo "Usage: $0 {backup|restore}"
  exit 1
  ;;
esac
