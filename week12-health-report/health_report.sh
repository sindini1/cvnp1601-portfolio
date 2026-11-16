#!/bin/bash
# ============================================================================
# health_report.sh - Daily server health report
# Author: Sincere Harvey
# Course: CVNP1601 Linux Administration
# Purpose: Collect disk, inode, memory, load, vmstat, and listening service
#          evidence into a timestamped report that starts with hostname and date.
# ============================================================================

# WHY: one place for the report directory so the path is easy to change later
REPORT_DIR="$HOME/reports"
# WHY: mkdir -p so the first run does not fail if the folder is missing
mkdir -p "$REPORT_DIR"

# WHY: hostname and timestamp go in the header so the report identifies itself
HOSTNAME=$(hostname)
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S %Z")
# WHY: unique filename so each run keeps its own evidence
REPORT_FILE="$REPORT_DIR/health_${HOSTNAME}_$(date +%Y%m%d_%H%M%S).log"

{
  echo "========================================"
  echo "Server Health Report"
  echo "Hostname: $HOSTNAME"
  echo "Timestamp: $TIMESTAMP"
  echo "========================================"
  echo

  echo "=== Disk Usage (df -h) ==="
  df -h
  echo

  echo "=== Inode Usage (df -i) ==="
  df -i
  echo

  echo "=== Memory (free -h) ==="
  free -h
  echo

  echo "=== Load and Uptime ==="
  uptime
  echo "CPU cores: $(nproc)"
  echo

  echo "=== vmstat samples ==="
  # WHY: vmstat 1 5 takes five one-second samples. Skip the first data line
  # when interpreting because it is the average since boot.
  vmstat 1 5
  echo

  echo "=== Listening Services (ss -tlnp) ==="
  ss -tlnp
  echo
} > "$REPORT_FILE"

echo "Report written to $REPORT_FILE"
exit 0
