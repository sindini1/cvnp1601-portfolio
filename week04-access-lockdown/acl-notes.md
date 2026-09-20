# Task 5 notes

## When an ACL is better than a group
Standard mode bits have one group slot. alice and bob already use developers for team write. Carlos needs read-only for one week. Adding him to developers would also give him write, and the membership would likely stay after the contract ends.

A named user ACL grants only Carlos, only r-x, and setfacl -x removes it without touching the team group.

## What the audit file should show
1. Baseline getfacl before any setfacl.
2. user:carlos:r-x and a mask line after setfacl -m.
3. default:group:developers:rw- after setfacl -d.
4. getfacl on acl-test.txt inheriting that default group entry.
5. After setfacl -x, user:carlos is gone from /project.

ls -ld /project should show a trailing + while the named ACL exists.
