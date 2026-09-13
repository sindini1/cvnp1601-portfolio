# Week 3 Diagnosis

Ticket: contractor sudo rule in /etc/sudoers.d is ignored

## 1. State
The trainee wrote a valid looking rule with nano: contractor ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx.
cat printed that same line, so the text on disk is right.
ls -l shows the file exists, owned by root:root, mode 644 (-rw-r--r--).
After su - contractor, sudo -l says the user may not run sudo on web03.
The account switch worked.
The rule did not load.
Nothing in the transcript shows a syntax typo in the command path.

## 2. Root cause
sudo ignores a drop-in under /etc/sudoers.d/ when the file mode is too open.
This file is 644.
Those files need to be 0440.
visudo sets that mode for you.
The rule is being skipped, so contractor has no sudo rights.
sudo is not caching an old permission list.
It rereads policy on each run.

## 3. Remediation
Fix the mode first:

sudo chmod 0440 /etc/sudoers.d/contractor

Then check the file with visudo so the next edit cannot ship a bad file:

sudo visudo -c -f /etc/sudoers.d/contractor

Later edits should use sudo visudo -f /etc/sudoers.d/contractor, not sudo nano.

## 4. Verification
Check it two ways.

1. ls -l /etc/sudoers.d/contractor should show -r--r----- (0440) owned by root.
2. su - contractor, then sudo -l. The nginx restart command should list. sudo systemctl restart nginx should work and sudo systemctl stop nginx should still be denied.

Do not reboot to clear a cache.
There is no sudoers cache like that.
A reboot leaves 644 in place, the file stays ignored, and you still have not proven why access failed.
