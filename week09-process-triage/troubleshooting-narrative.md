1. What went wrong?
The lab VM was burning CPU and nginx would not stay up. The CPU came from a while true loop I started in the background. nginx failed because I put a bad line in nginx.conf. The trainee ticket is a different miss: they treated Operation not permitted as an unkillable process.

2. What evidence did I check first?
ps aux --sort=-%cpu for the hot process, including USER, PID, CPU, and COMMAND. Then systemctl status nginx and journalctl -u nginx -n 50 --no-pager before any successful restart.

3. What did I try?
I sent kill to the loop PID and checked ps after a short wait. For nginx I saved the journal to ~/reports/diagnosis_YYYYMMDD_HHMMSS.txt, then looked at the error before editing the config.

4. What fixed it?
The loop died on SIGTERM. For nginx I removed the bad line, ran sudo nginx -t, then sudo systemctl restart nginx. For the trainee, the fix is sudo kill 5502 because the worker is owned by www-data.

5. How did I verify the result?
ps no longer showed the loop PID. systemctl is-active --quiet nginx && echo "nginx is up" printed nginx is up. The timestamp on the diagnosis file is before the successful restart.

6. What was the security or reliability impact?
Killing by name or by the wrong owner can take down the wrong workload. Restarting before the journal is saved throws away the failure evidence. A permission error on kill is not a reason to reboot. It is a reason to read the USER column and use sudo.
