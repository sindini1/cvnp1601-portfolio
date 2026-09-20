1. What went wrong or could have gone wrong?
Write on a directory also lets you delete files inside it. Without the sticky bit, bob can delete alice's file even if he does not own it.
Without SGID, alice's new files stay in group alice and bob cannot use them as a teammate.
Adding Carlos to developers would leave him in the group after the contract ends.
chmod 777 looks like a fix and just opens the folder to everybody.
SUID on a shell script does nothing because the kernel ignores SUID on files that start with #!.
A capital S or T means the special bit is on and execute is off. That is usually a mistake.

2. What evidence did I check first?
ls -ld /project for the permission string and any `+`.
ls -l on before-sgid.txt and after-sgid.txt for the group column.
getfacl /project for Carlos, the mask, and the default lines.
id carlos to make sure he was not in developers.
umask, then the mode on a new file.

3. What did I try?
chmod +t and chmod g+s one at a time.
alice created a file. bob tried to rm it.
setfacl -m for Carlos, setfacl -d for the default developers entry, setfacl -x to remove Carlos.
chmod 750 on ~/deploy.sh.
chown $(whoami):developers /project.

4. What fixed it or what I would try next?
Sticky bit for the delete problem.
SGID for group inheritance.
A named ACL for the contractor.
If setfacl says Operation not supported I would check that the filesystem has acl enabled before I change the command.

5. How did I verify the result?
ls -ld /project showed s, t, and + after the ACL.
bob's rm said Operation not permitted and alice-file.txt was still there.
after-sgid.txt was group developers. before-sgid.txt was not.
getfacl showed user:carlos:r-x.
After setfacl -x that line was gone.

6. What was the security impact?
777 gives random accounts the same write and delete rights as the team.
A contractor in developers keeps access after they leave.
An ACL with rwx instead of r-x would let Carlos change or delete project files.
SUID on a script is fake privilege. Use a sudoers rule for one command instead.
