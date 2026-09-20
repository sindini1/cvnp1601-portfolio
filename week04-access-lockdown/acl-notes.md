# Task 5 notes

## When an ACL is better than a group
Normal permissions only have one group slot. alice and bob already use developers for the team. Carlos only needs read for a week.
If I added him to developers he would also get write, and somebody would probably forget to take him back out.

setfacl -m u:carlos:r-x gave just Carlos read and enter. setfacl -x took it off without touching the team group.

## What showed up in acl-audit.txt
First getfacl was the baseline. No Carlos.
After setfacl -m I got `user:carlos:r-x` and a mask line.
After setfacl -d I got `default:group:developers:rw-`.
acl-test.txt picked up that default group entry.
After setfacl -x the Carlos line was gone.
ls -ld still showed a `+` because the default ACL was still on the directory.
