# Non-root failure and log permissions

The failure test is not only about tar. Two permission checks happen in the same run.

1. tar cannot read protected files under /etc as a normal user. That is why the archive is tiny or missing and why tar prints Permission denied.
2. The log path is /var/log/backup_etc.log. A normal user cannot create or append that file. If the script opens the log before the if, the non-root run can fail on the log open and never reach the tar test.

Observed non-root result: no Backup succeeded line, Permission denied from tar on protected paths, and a non-zero exit. If the log file does not already exist and is not writable, the same run also fails to write the ERROR line. That is expected. It is not a second bug.

How I accounted for it:
- The success path is the sudo run. That user can read /etc and can write /var/log.
- The failure path is the non-root run. I treat both the tar denial and the log-write denial as the same class of evidence: the script did not report success.
- If a future version needs a non-root failure test that still writes a log, the log path has to be somewhere the user can write, or the log open has to fail into a visible message instead of a silent exit.
