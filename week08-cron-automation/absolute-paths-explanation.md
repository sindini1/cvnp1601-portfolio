# Why absolute paths and 2>&1 matter (Task 2)

Cron jobs need absolute paths because cron does not run from your home directory and does not load your normal shell environment or PATH. A relative path such as scripts/disk_report.sh will not be found and the job fails silently. The full path /home/student/scripts/disk_report.sh works regardless of the working directory cron starts in.

The 2>&1 redirect matters because most student VMs do not have a mail system configured for cron. Without 2>&1, any error messages written to stderr simply disappear. Redirecting stderr into the same log file as stdout turns a silent failure into a visible one that you can diagnose from the log.
