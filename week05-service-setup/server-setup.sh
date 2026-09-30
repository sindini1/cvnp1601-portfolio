#!/bin/bash
# Script: server-setup.sh
# Purpose: Install nginx, enable it at boot, start it now, and prove it is running
# Author:  sindini
# Date:    2026-09-30
# Usage:   sudo bash ~/server-setup.sh
# Notes:   Tested from a clean state after apt purge. Do not skip the verify block.

set -e

echo "=== server-setup.sh starting ==="

# WHY: apt uses the local package index. If that list is stale you can
# install an old nginx or miss the package entirely.
echo "[1/3] Refreshing package lists"
sudo apt update

# WHY: nginx must be on disk before systemctl can manage the unit.
# -y answers yes for you so the script does not hang on a prompt when
# nobody is sitting at the terminal.
echo "[2/3] Installing nginx"
sudo apt install -y nginx

# WHY: enable makes the unit start after every reboot.
# --now also starts it immediately so you do not have to run start separately.
echo "[3/3] Enabling and starting nginx"
sudo systemctl enable --now nginx

# WHY: install and enable can print success and still leave the daemon down.
# is-active --quiet returns 0 only when the service is running.
# exit 1 stops a silent failure from looking like a finished setup.
echo "Verifying nginx is active"
if systemctl is-active --quiet nginx; then
  echo "SUCCESS: nginx is active and running"
  echo "is-active:  $(systemctl is-active nginx)"
  echo "is-enabled: $(systemctl is-enabled nginx)"
else
  echo "ERROR: nginx failed to start" >&2
  systemctl status nginx --no-pager >&2 || true
  exit 1
fi

echo "=== server-setup.sh finished ==="
