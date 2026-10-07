# Code trace for the if block

Realistic failure: run the script without sudo, so tar cannot read protected files under /etc.

1. mkdir -p "$BACKUP_DIR" still works for a user-writable path, or fails if /var/backups/etc is root-only. That is a separate check.
2. log writes the start lines through tee -a. Those lines are not the success test.
3. if runs tar -czf "$ARCHIVE" /etc. tar hits a protected file, prints Permission denied, and exits non-zero.
4. Because tar is the command in the if, bash takes the else branch.
5. else calls log "ERROR: Backup failed" and exit 1.
6. Evidence: the log line says ERROR, and echo $? prints 1. ls may still show a partial archive. Do not trust the file unless the log says succeeded and the size is real.

The trainee version piped tar into tee, so step 4 scored tee instead. That is why their log said succeeded.
