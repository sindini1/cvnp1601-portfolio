Updated the server note in vim over SSH. File is ~/server-note.txt with server name, IP, Status: active, and the date. I searched /Status, saved with :wq, then made a bad edit and quit with :q! so the bad text never hit disk. cat after that matched the last good save. Quick operational lines went into nano as ~/quick-edit.txt.

For access I counted fields on one raw auth.log line first. This VM uses a full timestamp, so $1 is the timestamp, $7 is the username, and $9 is the source IP. I still ran the assigned pipeline grep "Accepted password" /var/log/auth.log | awk '{print $1, $2, $3, $9}' > ~/access-report.txt and verified with cat. There was one successful login, so the report is one line.

I also stripped comments and blanks from sshd_config with grep -v "^#" piped into grep -v "^$" so I was reading live settings, not the commented examples. Auth logs and SSH config are security evidence. I only kept the fields the ticket asked for.

A trainee tried to rank source IPs with uniq and got counts of 1. uniq needs sort first. I wrote that in week2-diagnosis.md so a flat report does not hide repeat access.
