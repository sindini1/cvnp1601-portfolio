# Task 4 notes

## Why SGID
A new file normally takes the creator's primary group. Alice's primary group is alice, so before-sgid.txt is group alice and bob may not have group access to it.

chmod g+s on a directory makes new files inherit that directory's group. After SGID, after-sgid.txt is group developers. The team keeps shared group access without anyone remembering to chgrp every file.

## What ls should show
ls -ld /project should have s in the group execute slot, like drwxrwsr-t.
before-sgid.txt group column: alice
after-sgid.txt group column: developers
The old file does not change group. SGID only affects files created after the bit is set.
