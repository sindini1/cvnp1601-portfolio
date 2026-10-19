# Week 8 Break/Fix Diagnosis

## 1. State
The manual run of `disk_report.sh` on July 19 succeeded and wrote a full report that included the "Extended report (duf)" section. The crontab entry is present and uses absolute paths with `2>&1`. Syslog shows cron attempted the job on July 20. The July 20 entry in `disk_report.log` has the start timestamp and `df -h` output but is missing the duf section. The cron log ends with "duf: command not found".

## 2. Root cause
The single most likely reason is that cron runs with a limited environment and a minimal PATH. The `duf` command is available in the interactive shell (so the manual run finds it) but is not in the PATH that cron provides. Bash is not randomly skipping a line; the command simply cannot be found when the script runs under cron.

## 3. Remediation
The first fix is to replace the bare `duf` call with its absolute path. Find the full path with `which duf` or `command -v duf` in the interactive shell, then edit the script so the line becomes something like `/usr/local/bin/duf` (or whatever the actual path is) instead of just `duf`. Alternatively, add an explicit `PATH` export near the top of the script that includes the directory containing duf.

## 4. Verification
Confirm from two independent angles:
1. Run the updated script manually and check that `disk_report.log` still contains the duf section.
2. Temporarily set a frequent cron schedule (`*/2 * * * *`), wait for at least one run, then check both `disk_report.log` (or the cron log) for the duf output and `grep CRON /var/log/syslog` (or `journalctl -u cron.service`) to prove cron executed the job and the command succeeded.
