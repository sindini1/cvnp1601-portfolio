# Task 1 written breakdown

Replace the sample strings below with the exact lines from permission-audit.txt after you run the command on the VM.

## /etc/shadow
Typical string: -rw-r----- 1 root shadow
- pos 1 `-` regular file
- owner `rw-` root can read and write the hash file
- group `r--` shadow group can read
- other `---` nobody else can read password hashes
- no special bit, no ACL `+`
This is sensitive. World-readable shadow would let anyone copy hashes for offline cracking.

## /usr/bin/passwd
Typical string: -rwsr-xr-x 1 root root
- pos 1 `-` regular file
- owner `rws` read, write, and SUID. The `s` sits in the owner execute slot
- group `r-x` others in root group can run it
- other `r-x` any user can run it
- lowercase `s` means SUID and owner execute are both set
This is why a normal user can change their own password. The binary runs as root. SUID on a script would be ignored.

## /tmp
Typical string: drwxrwxrwt
- pos 1 `d` directory
- owner `rwx` root can list, create, delete
- group `rwx` group can do the same
- other `rwt` everyone can create files, sticky bit is set
- `t` is in the other execute slot
Sticky bit means you can only delete your own files in /tmp, not someone else's.

## /project
After the official setup only (mkdir + chown, no extra chmod yet) this is usually:
drwxr-xr-x 2 root developers
- pos 1 `d` directory
- owner `rwx` root
- group `r-x` developers can enter and read, not write yet
- other `r-x`
- no sticky bit, no SGID, no `+` yet
If your listing already shows `rwx` for group or `t`/`s`/`+`, you already changed it. Put the real string from permission-audit.txt here.

## umask
Typical value: 0022
- leading 0 is the special-bits octet
- 022 removes write from group and other
- new file base 666 - 022 = 644 (rw-r--r--)
- new directory base 777 - 022 = 755 (rwxr-xr-x)
Confirm the printed umask in permission-audit.txt before you keep these numbers.
