# Troubleshooting Narrative

What went wrong or could have gone wrong is that a cron job can appear in crontab -l yet produce no log output if the script uses a relative path, if a command is missing from cron's PATH, or if stderr is not redirected. In this case the most likely silent failure would have been the duf command not being found under cron even though the rest of the script ran.

The evidence I checked first was crontab -l to confirm the entry was saved, then the script's own log file for timestamped output, and finally grep CRON /var/log/syslog (or journalctl -u cron.service) to see whether the daemon had attempted the job.

What I tried was running the script manually with bash to confirm it worked in an interactive shell, then adding the absolute path and 2>&1 redirect in the crontab entry, and finally using a frequent test schedule so I could observe multiple runs without waiting a week.

What fixed it was ensuring the crontab used the full absolute path to the script and redirected both stdout and stderr into the same log file, plus confirming the script itself used mkdir -p and append redirects so it could not fail silently on a missing directory.

I verified the result by confirming at least two timestamped entries appeared in the script log after the test schedule ran, matching CMD lines in syslog, and then switching to the final weekly schedule and re-checking crontab -l.

The security and reliability impact is that automation without captured logs is not auditable; a failed disk report can hide storage exhaustion until services stop writing data or logs, so timestamped evidence from both the script and the system log is required to prove the job actually succeeded.
