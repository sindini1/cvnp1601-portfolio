#!/bin/bash
# ============================================================================
# disk_report.sh - Weekly disk usage report for ops team
# Author: Sincere Harvey
# Course: CVNP1601 Linux Administration
# Purpose: Automate disk usage reporting with timestamped logging
# ============================================================================

# Variables with quoted paths
LOG_DIR="$HOME/logs"
LOG_FILE="$LOG_DIR/disk_report.log"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Timestamp for log entries
TIMESTAMP=$(date "+%a %b %d %H:%M:%S %Z %Y")

# Append timestamped header and disk usage
{
  echo "$TIMESTAMP -- Disk Report Start"
  echo "$TIMESTAMP -- Filesystem usage (df -h):"
  df -h
  echo "$TIMESTAMP -- Disk Report End"
  echo ""
} >> "$LOG_FILE"

# Optional: exit cleanly
exit 0
