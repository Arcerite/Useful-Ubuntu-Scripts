# Update-Ubuntu-On-Boot 🐧

By Caleb Peters / Arcerite  
A lightweight Bash script to automatically update an Ubuntu system on boot, log everything, and send a desktop notification when the update is complete.

This script handles updating system packages, fixing broken dependencies, cleaning up unused packages, and logging everything to a personal log directory. It’s designed for minimal setup and easy automation.

---

## 🧰 Features

- Updates system packages (`apt-get update` + `upgrade`)  
- Fixes broken dependencies automatically (`apt-get --fix-broken install`)  
- Cleans up unused packages (`autoremove` + `autoclean`)  
- Logs all output to a timestamped log file in your home directory  
- Sends a desktop notification when updates are complete  

---

## ⚙️ Prerequisites

- Ubuntu or Debian-based Linux  
- A user account to run the script  
- `notify-send` (usually included with `libnotify-bin`)  

Install `notify-send` if it’s missing:

```bash
sudo apt install libnotify-bin
```

---

## 🚀 Setup

1. **Clone the repository**

```bash
git clone https://github.com/Arcerite/Update-Ubuntu-On-Boot.git
cd Update-Ubuntu-On-Boot
```

2. **Edit the script**  

Open `update-system.sh` and set your username at the top:

```bash
USERNAME="your-username"
```

This ensures logs and notifications go to the correct user’s home directory.

3. **Make the script executable**

```bash
chmod +x update-system.sh
```

4. **Test the script manually**

```bash
sudo ./update-system.sh
```

You should see the update process run in the terminal and a desktop notification when it finishes.

---

## ⏰ Automate with Cron

To run the script automatically at system startup:

1. Edit your crontab:

```bash
crontab -e
```

2. Add this line to run at every boot:

```
@reboot sudo /full/path/to/update-system.sh
```

Replace `/full/path/to/` with the full path to your script.

---

## 📁 Logs

All updates are logged to:

```
/home/<USERNAME>/personal_logs/apt-update.log
```

Each run appends a timestamped entry so you can review your system update history.

---

## 📜 License

This project is licensed under the MIT License.  
You are free to use, modify, and distribute with attribution.

MIT License © 2025 Caleb Peters / Arcerite

---

## ✉️ Contact

Questions or suggestions? Open an issue or reach out via GitHub.
