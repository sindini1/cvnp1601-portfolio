1. What went wrong or could have gone wrong?
A bad edit can get saved if I use the wrong exit. The real failure mode in this ticket is quieter. The trainee piped tar into tee inside the if, so the log said Backup succeeded while tar had already printed Permission denied. Without sudo, tar cannot read protected files under /etc and the archive can be tiny. An unquoted path would also split if a directory name ever had a space.

2. What evidence did I check first?
I read the transcript in order. tar said it was exiting with failure. The next log line said Backup succeeded. echo $? was 0. ls showed a 128 byte archive. That combination means the if did not see tar's status.

3. What did I try?
I built backup_etc.sh with a shebang, variables at the top, a log() function using tee -a, and an if that runs tar by itself. On failure it logs ERROR and exits 1. I did not pipe tar into tee. Git on the Linux system got two commits: the logging script, then the archive-path verification line. I also checked git status after the add so the staged file was visible before the commit.

4. What fixed it or what I would try next?
Remove the pipe so the if tests tar directly. Redirect tar's stderr with 2>>"$LOG" if the errors still need to land in the file. Then run once without sudo and once with sudo. The non-root run also has to account for the log path. /var/log/backup_etc.log is not writable by a normal user, so a failure test that only looks at tar can still die on the log open before the if ever runs.

5. How did I verify the result?
The observed runs, not the expected ones, are the proof. With sudo, the script printed the starting line, tar completed, the log said Backup succeeded with the archive path, and echo $? was 0. ls -lh /var/backups/etc showed an archive on the order of hundreds of kilobytes, not 128 bytes. tar -tzf on that file listed real /etc paths. Without sudo, the run did not print a success line. tar reported Permission denied on protected files, and the script exited non-zero. The same non-root run also cannot append to /var/log/backup_etc.log unless that file is already writable by the user, so the log-open failure is part of the observed result, not a separate bug. git status after the add showed the script staged, and git log --oneline showed the two commits after the commit.

6. What was the security or reliability impact?
A green log with a broken archive is worse than a loud failure. Whoever restores from it during an incident has no reason to doubt the file until the configs they need are missing. Git history is the other half. Without commits, nobody can prove which version logged the false success.
