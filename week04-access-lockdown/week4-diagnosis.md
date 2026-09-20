# Week 4 Diagnosis

Ticket: /project is shared, group-writable, and broken in three ways

## 1. State
ls -ld /project starts as a group-writable directory owned by developers.
Bob can delete Alice's files because directory write includes unlink.
New files Alice creates belong to her primary group, not developers.
Carlos needs read access for one week and should not join developers.

## 2. Root cause
Three different controls are missing.
Standard owner/group/other bits cannot express "one extra user, temporary, read only."
The sticky bit is the control that blocks non-owner deletes in a shared directory.
SGID on a directory is the control that forces new files to inherit the directory group.
A named user ACL is the control that grants Carlos r-x without group membership.

## 3. Remediation
Inspect first.

sudo chmod +t /project
sudo chmod g+s /project
sudo setfacl -m u:carlos:r-x /project

Do not run chmod 777.
Do not run usermod -aG developers carlos for a short engagement.
Do not chmod u+s on a script. The kernel ignores SUID on #! files.

## 4. Verification
ls -ld /project should show drwxrwsr-t or drwxrwsr-t+ after the ACL.
As bob, rm /project/alice-file.txt should print Operation not permitted.
ls -l before-sgid.txt and after-sgid.txt should disagree in the group column.
getfacl /project should list user:carlos:r-x and a mask that allows it.
id carlos should not list developers.
setfacl -x u:carlos /project should drop that named entry.

A reboot is not part of the proof. These bits and ACL entries persist on the inode.
