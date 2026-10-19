# Technical Lead Note

The scheduled job runs `disk_report.sh` every Sunday at 06:00. The script creates the log directory if needed, appends a timestamped header, runs `df -h`, and appends a closing timestamp so each report is self-contained and historical entries are preserved. Output and any errors are captured in `/home/student/logs/disk_report_cron.log` via the crontab redirect `>> ... 2>&1`.

Evidence that the job actually ran comes from two independent sources: the script's own timestamped log file (proves the script executed and produced output) and syslog or journalctl entries that show the cron daemon attempted the CMD. The final schedule is `0 6 * * 0` so the report arrives before the Monday morning check the team used to do manually.

This automation reduces the reliability risk of a forgotten manual check and the audit risk of having no proof that storage monitoring occurred. A failed or missing report is now visible in the logs instead of remaining silent until a disk fills up and services start failing. The timestamped, append-only logs give the team a clear audit trail for storage capacity over time.
