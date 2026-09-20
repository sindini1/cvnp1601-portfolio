# Task 4 notes

## Why SGID
New files usually take your primary group. alice's primary group is alice, so before-sgid.txt came out as group alice. bob is not in that group, so team access breaks.

chmod g+s on the directory makes new files take the directory group instead. after-sgid.txt came out as group developers.

## What I saw
ls -ld /project showed `drwxrwsr-t`. The `s` is SGID.
before-sgid.txt stayed group alice. That file was already there.
after-sgid.txt was group developers.
SGID does not rewrite old files. It only changes what gets created after you set it.
