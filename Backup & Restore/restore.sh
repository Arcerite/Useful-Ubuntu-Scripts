#!/bin/bash
# Restore Survival Environment
# Run this after a fresh Ubuntu install to restore packages, configs, and keys

set -euo pipefail

# ===== CONFIG =====
BACKUP_DIR="$(dirname "$0")"      # assumes restore script is in the backup folder
USER_HOME="$HOME"

echo "===== Starting Survival Restore ====="

# ------------------------------
# 1. Restore system packages (APT)
# ------------------------------
if [ -f "$BACKUP_DIR/pkglist-debian.txt" ]; then
    echo "[+] Restoring APT packages..."
    sudo apt update
    # Only install packages marked as 'install'
    awk '$2 == "install" {print $1}' "$BACKUP_DIR/pkglist-debian.txt" | xargs -r sudo apt install -y
else
    echo "[!] No pkglist-debian.txt found, skipping system packages"
fi

# ------------------------------
# 2. Restore Python packages (user install, PEP 668-safe)
# ------------------------------
if [ -f "$BACKUP_DIR/pip-packages.txt" ]; then
    echo "[+] Restoring Python pip packages (user install)..."
    pip install --user --break-system-packages -r "$BACKUP_DIR/pip-packages.txt"
else
    echo "[!] No pip-packages.txt found, skipping pip restore"
fi

# Ensure ~/.local/bin is in PATH for user-installed packages
export PATH="$HOME/.local/bin:$PATH"

# ------------------------------
# 3. Restore dotfiles
# ------------------------------
if [ -d "$BACKUP_DIR/dotfiles" ]; then
    echo "[+] Restoring dotfiles..."
    rsync -a "$BACKUP_DIR/dotfiles/" "$USER_HOME/"
else
    echo "[!] No dotfiles backup found"
fi

# ------------------------------
# 4. Restore Sandbox / project files
# ------------------------------
if [ -d "$BACKUP_DIR/sandbox" ]; then
    echo "[+] Restoring Sandbox folder..."
    rsync -a "$BACKUP_DIR/sandbox/" "$USER_HOME/Sandbox/"
else
    echo "[!] No Sandbox folder backup found"
fi

# ------------------------------
# 5. Restore SSH and GPG keys
# ------------------------------
if [ -d "$BACKUP_DIR/ssh" ]; then
    echo "[+] Restoring SSH keys..."
    mkdir -p "$USER_HOME/.ssh"
    rsync -a "$BACKUP_DIR/ssh/" "$USER_HOME/.ssh/"
    chmod 700 "$USER_HOME/.ssh"
    chmod 600 "$USER_HOME/.ssh"/*
fi

if [ -d "$BACKUP_DIR/gnupg" ]; then
    echo "[+] Restoring GPG keys..."
    mkdir -p "$USER_HOME/.gnupg"
    rsync -a "$BACKUP_DIR/gnupg/" "$USER_HOME/.gnupg/"
    chmod 700 "$USER_HOME/.gnupg"
fi

# ------------------------------
# 6. Optional reboot
# ------------------------------
read -rp "Do you want to reboot now? [y/N] " reboot_choice
if [[ "$reboot_choice" =~ ^[Yy]$ ]]; then
    echo "[+] Rebooting..."
    sudo reboot
else
    echo "[!] Reboot skipped. Log out or restart manually to apply all changes."
fi

echo "===== Restore Complete! ====="
