# Incident Worklog

Ticket: CVNP1601-W9-009. Server hot, internal web page down.

## Root cause
Two separate problems. A background bash loop was spinning a core. nginx was down because of a config syntax error I introduced in the lab so the failure could be diagnosed.

## What I checked
ps aux --sort=-%cpu showed the loop, its PID, owner, and CPU. pgrep -la bash confirmed the command. systemctl status nginx showed failed. journalctl -u nginx --no-pager showed the config error before I changed anything.

## Fix
Sent SIGTERM to the loop PID and confirmed it was gone. Captured the nginx journal to a timestamped file under ~/reports before editing. Removed the bad line in nginx.conf, ran nginx -t, then restarted.

## Verification
ps aux | grep PID no longer showed the loop. systemctl is-active --quiet nginx printed nginx is up. Evidence file is the diagnosis_*.txt captured before the successful restart.
