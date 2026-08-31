I SSHed into the lab VM and treated it like a ticket. First thing I did was figure out where I was with pwd and ls /. That showed the usual folders like /etc, /var/log, /home, /usr/bin, and /tmp. I kept running pwd after I moved because otherwise a screenshot is useless.

cd etc from my home folder failed. There is no etc in /home/sindini. The real one is /etc. After that I used full paths.

find on /etc dumped a bunch of Permission denied lines until I added 2>/dev/null. The command still worked. Those errors are just paths my user cannot read.

For the log I ran wc -l on /var/log/syslog, then grep -i error piped to head and wc -l. I saved errors with > into errors.txt and appended warnings with >>. Quiet output is normal when you redirect.

A trainee thought log rotation ate their file. They used > twice and overwrote 215 lines with 3. I wrote that up in the diagnosis. Week 1 is collect evidence, not fix the app.
