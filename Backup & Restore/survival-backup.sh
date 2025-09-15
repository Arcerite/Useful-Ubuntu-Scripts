#!/bin/bash
# Survival Backup Script
# Minimal environment backup for fast recovery

set -euo pipefail

BACKUP_DIR="$HOME/survival-backup"
LOGFILE="$HOME/personal_logs/survival-backup.log"

mkdir -p "$BACKUP_DIR"

exec >>"$LOGFILE" 2>&1
echo "===== Survival Backup Run: $(date) ====="

# 1. Sandbox
echo "[+] Backing up sandbox..."
rsync -a --delete "$HOME/Sandbox/" "$BACKUP_DIR/sandbox/"

# 2. Dotfiles
echo "[+] Backing up dotfiles..."
mkdir -p "$BACKUP_DIR/dotfiles/"

for f in "$HOME/.bashrc" "$HOME/.zshrc"; do
  if [ -f "$f" ]; then
    rsync -a "$f" "$BACKUP_DIR/dotfiles/"
  fi
done

if [ -d "$HOME/.config" ]; then
  rsync -a --delete "$HOME/.config/" "$BACKUP_DIR/dotfiles/.config/"
fi


# 3. SSH & GPG keys
echo "[+] Backing up SSH and GPG keys..."
rsync -a --delete "$HOME/.ssh/" "$BACKUP_DIR/ssh/"
rsync -a --delete "$HOME/.gnupg/" "$BACKUP_DIR/gnupg/"

# 4. System package list (Ubuntu/Debian only)
echo "[+] Saving system package list..."
dpkg --get-selections > "$BACKUP_DIR/pkglist-debian.txt"

# 5. Python packages
if command -v pip >/dev/null 2>&1; then
  echo "[+] Saving pip packages..."
  pip freeze > "$BACKUP_DIR/pip-packages.txt"
fi

# 6. Commit & push to Git
echo "[+] Committing and pushing to Git..."
cd "$BACKUP_DIR"
git add .
git commit -m "Survival backup: $(date +'%Y-%m-%d %H:%M:%S')" || true
git push origin main

echo "[✓] Backup complete at $(date)"
