# Task 3 notes

## Why the sticky bit
If a directory is group-writable, write also means you can delete files in it. alice and bob are both in developers, so without the sticky bit bob could delete alice-file.txt even though he does not own it.

I set the sticky bit with chmod +t. After that bob's rm printed Operation not permitted and the file was still there.
That is the point. People can still add files. They cannot wipe each other's work.

## What I saw
ls -ld /project showed `drwxrwxr-t`.
The `t` is in the other execute slot. Lowercase t means sticky bit and execute are both on.
