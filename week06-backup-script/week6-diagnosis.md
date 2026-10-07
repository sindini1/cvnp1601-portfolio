# Week 6 Diagnosis

Ticket: trainee backup script logged success after tar printed Permission denied.

## 1. State
The script ran. tar printed "Cannot read: Permission denied" and "Exiting with failure status due to previous errors." The log still says "Backup succeeded" with the archive path. echo $? printed 0. ls -lh shows a 128 byte archive owned by root. The if branch that means success fired. The error branch did not. bash if is not broken. The success message is wrong.

## 2. Root cause
tar is piped into tee -a "$LOG" inside the if. A pipeline's exit status is the status of the last command, which is tee. tee wrote the errors and exited 0, so if treats the whole line as success and the script exits 0. tar's failure status never reaches the if. The tiny archive is leftover from a tar that could not read protected files.

## 3. Remediation
Stop piping tar. Test tar's own exit status in the if.

if tar -czf "$ARCHIVE" /etc 2>>"$LOG"; then
  log "Backup succeeded: $ARCHIVE"
else
  log "ERROR: Backup failed"
  exit 1
fi

Do not put tee on that same line. log() can still use tee -a for messages. If they insist on a pipe, set -o pipefail first so the if sees tar's failure. The assignment wants the direct test, so remove the pipe.

## 4. Verification
Check it two ways.

1. Run bash backup_etc.sh with no sudo. echo $? should be 1 and the log should say ERROR: Backup failed, not Backup succeeded.
2. Run sudo bash backup_etc.sh. echo $? should be 0, the log should say Backup succeeded, and ls -lh /var/backups/etc should show an archive much bigger than 128 bytes. tar -tzf on that file should list real /etc paths.

A green log line with a broken archive is worse than a loud failure. An incident responder would trust the success line and restore from a file that never captured the protected configs.
