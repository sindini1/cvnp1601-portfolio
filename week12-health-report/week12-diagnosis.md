# Week 12 Break/Fix Diagnosis

## State
The crontab -l output shows a correct PATH line and the daily 6:00 AM entry that points at /home/student/scripts/health_report.sh and redirects output to health_cron.log. ls -la shows only one report file, health_web12_20260718.txt, last modified July 18 at 06:00. The date command shows it is now July 22, so four days have passed with no new report. ps shows one health_report.sh process that has been running for 3 days and 3 hours, and a child vmstat 1 process that has been running for the same length of time.

## Root cause
The script is calling vmstat 1 with no sample count. Without the second number, vmstat runs forever and never exits. The script therefore never reaches the end of its output redirection, the report file is never closed, and the job stays stuck. Subsequent cron runs either do not start or do not produce a finished report because the previous instance is still holding the work.

## Remediation
First kill the hung process so the job can be fixed:

kill 4821

Then edit the script and change the vmstat line to a finite sample:

vmstat 1 5

Save the file, make sure it is still executable, and run it once by hand:

bash ~/scripts/health_report.sh
ls -la ~/reports/health_*.log

## Verification
Check two independent angles. First, confirm the stuck process is gone:

ps -eo pid,etime,cmd | grep health_report

The only line should be the grep itself. Second, confirm a new report file appeared with a current timestamp and that its header contains the hostname and the new date. Also check that the next scheduled run (or a temporary test schedule) writes a fresh file and that health_cron.log receives output.

## Security note
A monitoring script that silently stops producing new reports creates a false sense of safety. Operators who only look at the existence of the reports folder may assume the server is fine when the last successful capture is days old. That blind spot is worse than having no automated report at all because it looks like coverage while actually providing none.
