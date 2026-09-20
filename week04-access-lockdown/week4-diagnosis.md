# Week 4 Diagnosis

Ticket: a trainee set SUID on backup.sh so developers could run a backup as root without sudo. ls shows the bit. The script still prints Running as: alice.

## 1. State
chown root:root worked. chmod u+s worked. ls -l backup.sh is `-rwsr-xr-x 1 root root`, so the setuid bit is actually on and root owns the file.
whoami in the shell is alice. ./backup.sh prints Running as: alice. It did not run as root.
The trainee thinks chmod is broken, or that they still need sudoers on top. The transcript does not show chmod failing. The bits took. The process just did not become root.

## 2. Root cause
backup.sh is a script. It prints $(whoami), so it is being interpreted, not run as a compiled binary.
The kernel ignores SUID on scripts. It starts whatever is in the shebang, usually /bin/bash. bash is not SUID. The script is just an argument. EUID stays alice, so whoami prints alice.
The lowercase s in `-rwsr-xr-x` is real. It just does not do what they think on a #! file.

## 3. Remediation
Do not chmod u+s on the script. Do not chmod u+s on bash. Do not chmod 4777.
Give them a sudoers rule for that one file.
Example: `developers ALL=(root) NOPASSWD: /opt/scripts/backup.sh`
Put it under /etc/sudoers.d/ and check it with visudo -c.
That is the small path. SUID on bash would make every script root. Sudoers names one command.

## 4. Verification
Two checks.
First, prove the old way cannot work. head -1 /opt/scripts/backup.sh should start with #!. After chmod u+s, running it as alice still prints Running as: alice.
Second, prove the sudoers fix. sudo -l -U alice should list /opt/scripts/backup.sh. Then running it through sudo should print Running as: root.
You do not need to leave the s bit on the script. chmod u-s after the sudoers rule is in so ls stops looking like it already works.
