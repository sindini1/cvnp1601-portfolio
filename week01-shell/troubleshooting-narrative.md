1. What was the ticket?
A developer said the web app on the server started throwing errors. Manager wanted evidence from the shell.

2. Where did I start?
I ran pwd and ls / so I knew I was on the box and could find /etc, /var/log, /home, /usr/bin, and /tmp.

3. How did I move around without getting lost?
I used cd with absolute paths like /var/log, then pwd after each move. cd - went back. cd .. went up one level. cd etc from home failed because etc is not inside my home folder.

4. How did I find files and keep the output clean?
find /etc -name "*.conf" dumped Permission denied lines until I added 2>/dev/null. Those denials are the system protecting private paths, not a broken command.

5. How did I turn the log into evidence?
wc -l /var/log/syslog showed how big the log was. grep -i "error" /var/log/syslog | head -20 showed samples. grep -i "error" /var/log/syslog | wc -l counted hits. I wrote errors to errors.txt with > and appended warnings with >>.

6. What went wrong in the trainee transcript and what did I do about it?
They used > a second time and overwrote 215 error lines with 3 critical lines. That is not log rotation. The fix is >> for the second search, then verify with wc -l and grep counts.
