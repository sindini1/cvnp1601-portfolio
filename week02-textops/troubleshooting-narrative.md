1. What went wrong or could have gone wrong?
A bad vim edit can get saved with :wq. On the access report, picking the wrong awk field prints the IP or hostname instead of the username. This lab log uses a full timestamp, so $9 is the source IP, not the account. The trainee report also failed because uniq ran on unsorted IPs, so 10.0.0.5 never grouped.

2. What evidence did I check first?
I ran cat ~/server-note.txt after :q! to prove the bad edit did not save. For logs I printed one raw Accepted password line and counted fields before writing the report. For SSH I compared PermitRootLogin search output against the active sshd_config lines after dropping comments.

3. What did I try?
vim for the note: insert, :w, /Status, :wq, then a throwaway edit and :q!. nano for the short note with Ctrl+O and Ctrl+X. grep -r, grep -v, and grep -iE for config and syslog. awk -F: on /etc/passwd and awk on auth.log.

4. What fixed it or what I would try next?
:q! fixed the bad vim pass. The report pipeline is grep "Accepted password" into awk '{print $1, $2, $3, $9}' redirected with >. For the trainee ticket the fix is sort before uniq -c.

5. How did I verify the result?
cat ~/server-note.txt and cat ~/quick-edit.txt. cat ~/access-report.txt next to the raw grep sample. For the IP counts I would compare uniq output to grep -c on 10.0.0.5 in src-ips.txt and in auth.log.

6. What was the security impact?
Active SSH settings and successful-login lines are evidence. If you read commented config you can think root login is off when it is on. If you ship unsorted uniq counts, repeat access from one IP looks rare and an incident review can miss it.
