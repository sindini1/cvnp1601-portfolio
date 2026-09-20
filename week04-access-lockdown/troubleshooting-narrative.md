1. What went wrong or could have gone wrong?
Write permission on a directory includes delete rights for files inside it. Without the sticky bit, Bob can delete Alice's file even when he does not own it.
Without SGID, new files take Alice's primary group and Bob cannot read them.
Adding Carlos to developers would leave a permanent membership that is easy to forget.
chmod 777 would look like a fix and would open the directory to every account on the system.
SUID on a shell script would do nothing because the kernel ignores SUID on files that start with #!.
A capital S or T means the special bit is on and execute is off. That is usually a mistake.

2. What evidence did I check first?
ls -ld /project for the ten-character string and any trailing +.
ls -l on before-sgid.txt and after-sgid.txt for the group column.
getfacl /project for user:carlos, the mask, and default: lines.
id carlos to prove he is not in developers.
umask, then ls -l on a new file and a new directory.

3. What did I try?
chmod +t and chmod g+s one bit at a time.
alice created a file. bob tried rm.
setfacl -m for Carlos, setfacl -d for the default developers entry, setfacl -x to show removal.
chmod 750 on ~/deploy.sh.
chown root:developers /project.

4. What fixed it or what I would try next?
Sticky bit for the delete problem.
SGID for group inheritance.
A named ACL for the contractor.
If setfacl says Operation not supported, check mount options for acl before changing syntax.

5. How did I verify the result?
ls -ld /project shows s, t, and + after the ACL.
bob rm is denied and alice-file.txt still exists.
after-sgid.txt is group developers. before-sgid.txt is not.
getfacl shows user:carlos:r-x and the mask does not block it.
After setfacl -x, that named user line is gone.

6. What was the security impact?
777 grants unrelated and compromised accounts the same write and delete rights as the team.
A contractor in developers keeps access after the engagement ends.
An ACL with rwx instead of r-x lets Carlos change or delete project files.
SUID on a script is a false sense of privilege. Use a targeted sudoers rule for privileged scripts.
