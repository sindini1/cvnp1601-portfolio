# Week 4 Diagnosis

Ticket: trainee set SUID on backup.sh so developers could run a backup as root without sudo. The bit shows in ls. The script still prints Running as: alice.

## 1. State
chown root:root worked. chmod u+s worked. ls -l backup.sh is -rwsr-xr-x 1 root root, so the setuid bit is on and the owner is root.
whoami at the shell is alice. ./backup.sh prints Running as: alice. Root privileges did not apply inside the script.
The trainee thinks chmod is broken or that sudoers still has to be added on top. The transcript does not show a chmod failure. The bits took. The process did not run as root.

## 2. Root cause
backup.sh is a script. The first thing it does is print $(whoami), which means it is interpreted, not a compiled binary.
The kernel does not honor SUID on scripts. It starts the interpreter listed in the shebang, usually /bin/bash. That interpreter is not SUID, and the script is only an argument to it. EUID stays alice, so whoami prints alice.
The lowercase s in -rwsr-xr-x is real. It just does not do what the trainee thinks it does on a #! file.

## 3. Remediation
Do not chmod u+s on the script. Do not chmod u+s on bash. Do not chmod 4777.
Use a targeted sudoers rule for that one command.
Example: developers ALL=(root) NOPASSWD: /opt/scripts/backup.sh
Drop a file under /etc/sudoers.d/ and check it with visudo -c.
That is the narrow privilege path. SUID on the interpreter would give every script root. Sudoers names one file.

## 4. Verification
Two independent checks.
First, prove the old approach cannot work: head -1 /opt/scripts/backup.sh should start with #!. After chmod u+s, sudo -u alice /opt/scripts/backup.sh or ./backup.sh as alice still prints Running as: alice.
Second, prove the sudoers fix: sudo -l -U alice should list /opt/scripts/backup.sh. Then sudo -u alice sudo /opt/scripts/backup.sh should print Running as: root.
ls -l backup.sh does not need to keep the s bit. Remove it with chmod u-s after the sudoers rule is in place so the misleading mode is gone.
