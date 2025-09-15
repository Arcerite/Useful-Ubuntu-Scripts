# Useful Ubuntu Scripts 🐧

By Caleb Peters / Arcerite  
A collection of practical Bash scripts to automate system maintenance, backups, and recovery for Ubuntu.

This repository contains scripts for:  

- Automatically updating your system on boot  
- Backing up and restoring your development environment, dotfiles, and important configurations  
- Fast recovery after a fresh Ubuntu install  

---

## 🧰 Included Scripts & Folders

### 1. Update Scripts (`Update-Scripts/`)
- **`update-system.sh`**: Automatically updates Ubuntu packages, fixes broken dependencies, cleans up unused packages, logs everything, and sends a desktop notification.  
- Can be scheduled to run on boot using `cron`.  
- Logs are stored in `~/personal_logs/apt-update.log`.

---

### 2. Backup & Restore Scripts (`Backup-Scripts/`)
- **`backup-survival.sh`**:  
  - Backs up your sandbox (`~/Sandbox`), dotfiles, system packages, Python packages, and optionally SSH/GPG keys.  
  - Optionally commits and pushes the backup to a **private Git repository**.  
  - Logs actions to `~/personal_logs/survival-backup.log`.

- **`restore-survival.sh`**:  
  - Restores from your backup folder.  
  - Reinstalls system packages, Python packages, dotfiles, and optionally SSH/GPG keys.  
  - Prompts to reboot after restoration.

> ⚠ **Security Note**: Do not push `.ssh` or `.gnupg` folders to a public repository. Only use private repos for sensitive backups.

---

### 3. Folder Structure Example

```
Useful-Ubuntu-Scripts/
├── Backup-Scripts/
│   ├── backup-survival.sh
│   ├── restore-survival.sh
├── Update-Scripts/
│   └── update-system.sh
└── README.md               # You are here
```

---

## ⚙️ Usage

### Update Script
```bash
chmod +x Update-Scripts/update-system.sh
./Update-Scripts/update-system.sh
```
- To run at boot:  
```bash
crontab -e
# Add:
@reboot sudo /full/path/to/Update-Scripts/update-system.sh
```

### Backup & Restore Scripts
```bash
chmod +x Backup-Scripts/backup-survival.sh Backup-Scripts/restore-survival.sh
./Backup-Scripts/backup-survival.sh
./Backup-Scripts/restore-survival.sh
```
- Review README warnings before pushing backups to Git.  
- Place backups in the `Backup-Scripts/` folder before running restore.

---

## 📜 License

This project is licensed under the MIT License.  
You are free to use, modify, and distribute with attribution.

MIT License © 2025 Caleb Peters / Arcerite

---

## ✉️ Contact

Questions or suggestions? Open an issue or reach out via GitHub.
