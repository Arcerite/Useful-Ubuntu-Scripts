#!/bin/bash
# Survival Backup Script (cache-excluded)
# Minimal environment backup for fast recovery

set -euo pipefail

USERNAME='arcerite'
BACKUP_DIR="$HOME/survival-backup"
LOGFILE="$HOME/personal_logs/survival-backup.log"

mkdir -p "$BACKUP_DIR"

# Redirect all output to log
exec >>"$LOGFILE" 2>&1
echo "===== Survival Backup Run: $(date) ====="

# 1. Sandbox
echo "[+] Backing up sandbox..."
rsync -a --delete \
    --exclude 'node_modules/' \
    --exclude '*.cache' \
    "$HOME/Sandbox/" "$BACKUP_DIR/sandbox/"

# 2. Dotfiles (exclude caches)
echo "[+] Backing up dotfiles..."
mkdir -p "$BACKUP_DIR/dotfiles/"

# Basic dotfiles
for f in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$f" ]; then
        rsync -a "$f" "$BACKUP_DIR/dotfiles/"
    fi
done

# Config folder (exclude caches)
if [ -d "$HOME/.config" ]; then
    rsync -a --delete \
        --exclude 'Code/CachedExtensionVSIXs/' \
        --exclude 'Code/Cache/' \
        --exclude 'google-chrome/component_crx_cache/' \
        --exclude '*.cache' \
    "$HOME/.config/" "$BACKUP_DIR/dotfiles/.config/"
fi

# 3. SSH & GPG keys
echo "[+] Backing up SSH and GPG keys..."
mkdir -p "$BACKUP_DIR/ssh" "$BACKUP_DIR/gnupg"
rsync -a --delete "$HOME/.ssh/" "$BACKUP_DIR/ssh/"
rsync -a --delete "$HOME/.gnupg/" "$BACKUP_DIR/gnupg/"

# 4. System package list (Ubuntu/Debian only)
echo "[+] Saving system package list..."
dpkg --get-selections > "$BACKUP_DIR/pkglist-debian.txt"

# 5. Python packages
if command -v pip >/dev/null 2>&1; then
    echo "[+] Saving pip packages..."
    pip freeze --user > "$BACKUP_DIR/pip-packages.txt"
fi

# 6. Git ignore caches to prevent them from being committed
cat > "$BACKUP_DIR/.gitignore" <<EOF
# VS Code caches
dotfiles/.config/Code/CachedExtensionVSIXs/
dotfiles/.config/Code/Cache/

# Chrome cache
dotfiles/.config/google-chrome/component_crx_cache/

# Node / Python
node_modules/
*.cache
__pycache__/
*.pyc
*.tmp
EOF

# 7. Commit & push to Git
echo "[+] Committing and pushing to Git..."
cd "$BACKUP_DIR"
git add .
git commit -m "Survival backup: $(date +'%Y-%m-%d %H:%M:%S')" || true
git push origin main

echo "[✓] Backup complete at $(date)"

# 8. Desktop notification
USER_ID=$(id -u "$USERNAME")
export DISPLAY=:0
export XDG_RUNTIME_DIR="/run/user/$USER_ID"

sudo -u "$USERNAME" DISPLAY=$DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
notify-send "Ubuntu Backup" "backup completed successfully ✅"
