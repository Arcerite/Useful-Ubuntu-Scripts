#!/bin/bash
# Restore Survival Environment
# Run this after a fresh Ubuntu install to restore packages and configs

set -euo pipefail

BACKUP_DIR="$(dirname "$0")"

echo "===== Starting Survival Restore ====="

# 1. System packages
if [ -f "$BACKUP_DIR/pkglist-debian.txt" ]; then
  echo "[+] Restoring APT packages..."
  sudo apt update
  # Install packages in one shot
  sudo xargs -a "$BACKUP_DIR/pkglist-debian.txt" apt install -y
else
  echo "[!] No pkglist-debian.txt found, skipping system packages"
fi

# 2. Python packages
if [ -f "$BACKUP_DIR/pip-packages.txt" ]; then
  echo "[+] Restoring Python pip packages..."
  pip install --user -r "$BACKUP_DIR/pip-packages.txt"
else
  echo "[!] No pip-packages.txt found, skipping pip restore"
fi

# 3. Dotfiles
if [ -d "$BACKUP_DIR/dotfiles" ]; then
  echo "[+] Restoring dotfiles..."
  rsync -a "$BACKUP_DIR/dotfiles/" "$HOME/"
else
  echo "[!] No dotfiles backup found"
fi

# 4. SSH and GPG keys (always restore)
if [ -d "$BACKUP_DIR/ssh" ]; then
  echo "[+] Restoring SSH keys..."
  rsync -a "$BACKUP_DIR/ssh/" "$HOME/.ssh/"
  chmod 700 "$HOME/.ssh"
  chmod 600 "$HOME/.ssh"/*
fi
if [ -d "$BACKUP_DIR/gnupg" ]; then
  echo "[+] Restoring GPG keys..."
  rsync -a "$BACKUP_DIR/gnupg/" "$HOME/.gnupg/"
  chmod 700 "$HOME/.gnupg"
fi

echo "===== Restore Complete! ====="

# 5. Reboot prompt
read -rp "Do you want to reboot now? [y/N] " reboot_choice
if [[ "$reboot_choice" =~ ^[Yy]$ ]]; then
  echo "[+] Rebooting..."
  sudo reboot
else
  echo "[!] Reboot skipped. You may need to log out or restart manually."
fi
