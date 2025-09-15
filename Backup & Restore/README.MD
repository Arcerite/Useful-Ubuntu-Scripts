# Survival Backup & Restore Scripts 🐧

By Caleb Peters / Arcerite  
A set of lightweight Bash scripts to backup and restore your Ubuntu environment for fast recovery after a system reinstall.

These scripts allow you to quickly backup your sandbox, dotfiles, system packages, Python packages, and optionally SSH/GPG keys, then restore them on a fresh system.

---

## 🧰 Included Scripts

### 1. `backup-survival.sh`
- Backs up:
  - Sandbox directory (`~/Sandbox`)  
  - Dotfiles (`~/.bashrc`, `~/.zshrc`, and optionally `.config/`)  
  - System package list (`dpkg --get-selections`)  
  - Python packages (`pip freeze`)  
  - SSH keys (`~/.ssh/`) and GPG keys (`~/.gnupg/`)  
- Optionally commits and pushes the backup folder to a Git repository.  
- Logs all actions to `~/personal_logs/survival-backup.log`.  

### 2. `restore-survival.sh`
- Restores from the backup folder:
  - System packages (`apt install` from saved list)  
  - Python packages (`pip install -r`)  
  - Dotfiles (`rsync` into `$HOME`)  
  - SSH and GPG keys (with correct permissions)  
- Prompts the user to reboot after restoring.  

---

## ⚠ Security Notes

- **SSH/GPG keys are sensitive!**  
  - Do **not push** the backup folder containing these files to a public repository.  
  - Only use a **private Git repository** if you enable the automatic push in `backup-survival.sh`.  

- **Dotfiles may contain sensitive information** such as API keys or credentials. Review before sharing.  

---

## ⚙️ Setup & Usage

### Backup

1. Make the script executable:

```bash
chmod +x backup-survival.sh
```

2. Run the script:

```bash
./backup-survival.sh
```

3. Optionally, configure the script to automatically commit and push to a private Git repo by editing the remote in the script.

---

### Restore

1. Make the script executable:

```bash
chmod +x restore-survival.sh
```

2. Run the script:

```bash
./restore-survival.sh
```

3. Follow prompts for reboot after restore.

---

## 📁 Recommended Folder Structure

```
survival-backup/
├── sandbox/
├── dotfiles/
├── ssh/        # Sensitive
├── gnupg/      # Sensitive
├── pkglist-debian.txt
├── pip-packages.txt
├── backup-survival.sh
└── restore-survival.sh
```

---

## 📜 License

This project is licensed under the MIT License.  
You are free to use, modify, and distribute with attribution.

MIT License © 2025 Caleb Peters / Arcerite

---

## ✉️ Contact

Questions or suggestions? Open an issue or reach out via GitHub.
