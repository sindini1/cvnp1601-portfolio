# Week 7 Diagnosis

Ticket: key login stopped after hardening. Trainee thinks the key is corrupt or expired.

## 1. State
ssh -v offered /home/trainee/.ssh/id_ed25519. The server still listed publickey,password, then returned Permission denied. ls -la shows .ssh is drwx------ and authorized_keys is -rw-------. Those modes match the checklist. The key file is not the problem. The last auth.log line is the real evidence: Authentication refused: bad ownership or modes for directory /home/student.

## 2. Root cause
OpenSSH checks the whole path, not just the two files on the checklist. /home/student is writable by group or others, or it is not owned by student. sshd refuses the key when the home directory is unsafe, even if .ssh is 700 and authorized_keys is 600. The key did not expire. authorized_keys is not corrupt.

## 3. Remediation
Check the home directory, then remove group and other write.

ls -ld /home/student
chmod go-w /home/student

If the owner is wrong, fix that too:

sudo chown student:student /home/student

Do not regenerate the key pair. The existing key is fine.

## 4. Verification
Check it two ways.

1. ls -ld /home/student should show the student owns it and there is no w in the group or other slots. A normal home is drwxr-xr-x.
2. From the client, ssh -v student@SERVER_IP should get past "Offering public key" and land a shell. auth.log should no longer say bad ownership or modes for /home/student.

A review that only checks .ssh and authorized_keys can miss the directory one level up. The daemon already named the bad path. Read that line before you throw the key away.
