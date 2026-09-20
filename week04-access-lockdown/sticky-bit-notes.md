# Task 3 notes

## Why the sticky bit
Write permission on a directory includes the right to delete files inside it, even files you do not own. /project is group-writable for developers, and alice and bob are both in that group. Without the sticky bit, bob can rm alice-file.txt.

chmod +t sets the sticky bit. Only the file owner or root can delete or rename a file in that directory. Bob's rm prints Operation not permitted and alice-file.txt stays on disk. That is shared directory integrity: teammates can still create files, they cannot wipe each other's work.

## What ls should show
ls -ld /project should have t in the other execute slot, like drwxrwxr-t.
lowercase t means sticky bit and other-execute are both set.
