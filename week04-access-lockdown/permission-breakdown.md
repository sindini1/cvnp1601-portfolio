# Task 1 written breakdown

This is from permission-audit.txt on my lab VM.

## /etc/shadow
`-rw-r----- 1 root shadow`
It is a regular file. root can read and write it. The shadow group can read it. Everyone else is locked out.
That matters because this file has the password hashes. If other could read it, anyone on the box could copy the hashes and try to crack them offline.

## /usr/bin/passwd
`-rwsr-xr-x 1 root root`
The `s` in the owner spot is SUID. Anyone can run passwd, but it runs as root so a normal user can change their own password.
If this was a script instead of a binary, that SUID bit would not do anything.

## /tmp
`drwxrwxrwt`
The `t` is the sticky bit. Anyone can drop files in /tmp. You can only delete your own files, not somebody else's.

## /project
`drwxr-xr-x 2 root developers`
This was the starting state after setup. root owns it. developers can enter and list it, but they could not write yet. No sticky bit, no SGID, no `+` for an ACL.

## umask
My umask printed `0002`, not `0022`.
0002 only strips write from other. Group still keeps write.
New file: 666 - 002 = 664 (`rw-rw-r--`)
New directory: 777 - 002 = 775 (`rwxrwxr-x`)
I used those numbers, not the 644/755 example from class.
