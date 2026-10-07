#!/bin/bash
# backup_etc.sh
# CVNP1601 Week 6 - production /etc backup
# Archives /etc, logs every major step, and exits non-zero if tar fails.
# Another technician should be able to read the log and the Git history
# without asking who ran it.

# Paths live at the top so there is one place to change them later.
BACKUP_DIR="/var/backups/etc"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE="${BACKUP_DIR}/etc_${TIMESTAMP}.tar.gz"
LOG="/var/log/backup_etc.log"

# log() stamps a message and writes it to the screen and the log file.
# tee -a appends. Plain echo would disappear when the terminal closes.
log() {
  echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG"
}

# The archive folder has to exist before tar tries to write into it.
mkdir -p "$BACKUP_DIR"

log "Starting /etc backup"
log "Archive path: $ARCHIVE"

# Test tar's own exit status. Do not pipe tar into tee inside this if.
# A pipe would make if score tee, not tar, and a failed backup could look green.
if tar -czf "$ARCHIVE" /etc 2>/dev/null; then
  log "Backup succeeded: $ARCHIVE"
  # Verification line added after the first commit so Git history shows the change.
  ls -lh "$ARCHIVE"
else
  log "ERROR: Backup failed"
  exit 1
fi

log "Backup run finished"
exit 0
