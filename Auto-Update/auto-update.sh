#!/bin/bash

# Set the target username here
USERNAME="arcerite"

# Home directory of the user
USER_HOME="/home/$USERNAME"

# Log file location
LOGDIR="$USER_HOME/personal_logs"
LOGFILE="$LOGDIR/apt-update.log"

# Ensure the directory exists
mkdir -p "$LOGDIR"
chown "$USERNAME:$USERNAME" "$LOGDIR"

# Logging the update process
{
  echo "=== System Update: $(date) ==="
  apt-get update
  apt-get upgrade -y
  apt-get --fix-broken install -y
  apt-get autoremove -y
  apt-get autoclean
  echo "=== Update Complete ==="
} >> "$LOGFILE" 2>&1

# Desktop notification
USER_ID=$(id -u "$USERNAME")
export DISPLAY=:0
export XDG_RUNTIME_DIR="/run/user/$USER_ID"

sudo -u "$USERNAME" DISPLAY=$DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
  notify-send "System Update" "System has been updated successfully ✅"
