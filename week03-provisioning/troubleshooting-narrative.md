1. What went wrong or could have gone wrong?
A bad visudo save can lock sudo.
useradd without -m leaves no home directory.
usermod -G can wipe extra groups.
The contractor ticket failed because a sudoers.d file was mode 644, so sudo ignored a rule that looked correct.

2. What evidence did I check first?
id, grep on /etc/passwd, and ls -ld /home/devuser for the account.
grep on /etc/group for developers.
which systemctl before writing the rule.
sudo grep and sudo -l for the sudoers line.
ls -l on the trainee file showed 644.

3. What did I try?
useradd, passwd, groupadd, usermod -aG, then usermod -G for the comparison.
I read passwd, shadow, and group.
I installed nginx, used visudo, then tested restart and stop as devuser.

4. What fixed it or what I would try next?
The allow rule used the real path /usr/bin/systemctl.
For the contractor file the first fix is chmod 0440, then visudo -c -f /etc/sudoers.d/contractor.
Do not reboot to clear a cache sudo does not have.

5. How did I verify the result?
id showed developers.
sudo -u devuser sudo -l listed only restart nginx.
restart worked.
stop printed a deny.
ls -ld proved home exists.

6. What was the security impact?
Full sudo or the sudo group would over-grant access.
A world-open sudoers.d file can be ignored or become an escalation path.
The deny on stop is what proves the boundary.
Leaving hashes in a world-readable file would expose them to offline cracking.
