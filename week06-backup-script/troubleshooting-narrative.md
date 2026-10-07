1. What went wrong or could have gone wrong?
A bad edit can get saved if I use the wrong exit. The real failure mode in this ticket is quieter. The trainee piped tar into tee inside the if, so the log said Backup succeeded while tar had already printed Permission denied. Without sudo, tar cannot read protected files under /etc and the archive can be tiny. An unquoted path would also split if a directory name ever had a space.

2. What evidence did I check first?
I read the transcript in order. tar said it was exiting with failure. The next log line said Backup succeeded. echo $? was 0. ls showed a 128 byte archive. That combination means the if did not see tar's status.

3. What did I try?
I built backup_etc.sh with a shebang, variables at the top, a log() function using tee -a, and an if that runs tar by itself. On failure it logs ERROR and exits 1. I did not pipe tar into tee. Git on the Linux system got two commits: the logging script, then the archive-path verification line.

4. What fixed it or what I would try next?
Remove the pipe so the if tests tar directly. Redirect tar's stderr with 2>>"$LOG" if the errors still need to land in the file. Then run once without sudo and once with sudo.

5. How did I verify the result?
Without sudo, echo $? should be 1 and the log should say ERROR. With sudo, echo $? should be 0, tail on /var/log/backup_etc.log should show timestamps and Backup succeeded, and ls -lh /var/backups/etc should show an archive much larger than 128 bytes. tar -tzf on that archive is the second check that the contents are real /etc files.

6. What was the security or reliability impact?
A green log with a broken archive is worse than a loud failure. Whoever restores from it during an incident has no reason to doubt the file until the configs they need are missing. Git history is the other half. Without commits, nobody can prove which version logged the false success.
