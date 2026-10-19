# Cron Troubleshooting Note

When a job shows up in `crontab -l` but the script log never updates, the most common causes are path and environment problems. Cron does not start in your home directory and does not load your normal shell PATH or environment variables. A relative path like `scripts/disk_report.sh` fails because cron cannot find the file. Even with an absolute path, a command inside the script may fail if it is not in cron's limited PATH.

Permissions matter too: the cron user must be able to execute the script and write to the log directory. Always include `2>&1` so stderr is captured in the same log; without it, error messages disappear when no mail system is configured.

To tell "cron tried" from "the script succeeded," check syslog or journalctl for the CMD line (cron attempted the job) and the script's own log for actual output (script succeeded). First command to run when diagnosing no log output: `crontab -l` to confirm the entry is saved, then check the absolute path and `2>&1` redirect.
