# Week 08: Cron Automation Portfolio

## What I Can Do Now
This cron job runs a weekly Linux disk usage report, writes timestamped log evidence, and gives a sysadmin team proof that scheduled storage monitoring actually ran.

## AI Tool Use Statement
I used an AI assistant to help draft the initial structure of the troubleshooting notes and diagnosis write-up. I verified every command, path, and cron expression myself on the VM, tested the script manually before scheduling, and confirmed the root cause of the break/fix scenario by comparing the manual and cron log outputs side by side. I can explain without assistance why absolute paths are required, how `2>&1` captures errors, and the difference between crontab -l (scheduled) and the script log plus syslog (actually ran).
