# Task 1 written breakdown

Strings taken from permission-audit.txt on cvnp1601-lab, Sep 20 2026.

## /etc/shadow
`-rw-r----- 1 root shadow`
- pos 1 `-` regular file
- owner `rw-` root can read and write hashes
- group `r--` shadow group can read
- other `---` nobody else can read
- no special bit, no `+`
This file is sensitive. Other has no access so a normal account cannot copy hashes for offline cracking.

## /usr/bin/passwd
`-rwsr-xr-x 1 root root`
- pos 1 `-` regular file
- owner `rws` read, write, and SUID in the owner execute slot
- group `r-x` can run it
- other `r-x` any user can run it
- lowercase `s` means SUID and owner execute are both set
A normal user can change their password because this binary runs as root. SUID on a script would be ignored.

## /tmp
`drwxrwxrwt` (the `.` line under /tmp)
- pos 1 `d` directory
- owner `rwx`
- group `rwx`
- other `rwt` sticky bit in the other execute slot
- lowercase `t` means sticky and other-execute are both set
Anyone can create files in /tmp. The sticky bit stops a user from deleting someone else's file.

## /project
`drwxr-xr-x 2 root developers` (the `.` line under /project)
- pos 1 `d` directory
- owner `rwx` root
- group `r-x` developers can enter and list, not write yet
- other `r-x`
- no sticky bit, no SGID, no `+`
This is the before-state. Group write, sticky bit, SGID, and the Carlos ACL are not set yet.

## umask
Printed value: `0002`
- leading 0 is the special-bits octet
- 002 removes write from other only, group keeps write
- new file base 666 - 002 = 664 (rw-rw-r--)
- new directory base 777 - 002 = 775 (rwxrwxr-x)
This is not 0022. Do not use the 644/755 math on this VM.
