/project is group-writable for developers and now has three extra controls.

Sticky bit: chmod +t. Only the file owner or root can delete or rename files inside. Bob cannot remove Alice's work just because the directory is group-writable.

SGID: chmod g+s. New files inherit group developers instead of the creator's primary group. That keeps team read access consistent.

ACL: setfacl -m u:carlos:r-x /project. Carlos gets temporary r-x and is not in developers. Revoke later with setfacl -x u:carlos /project. Do not use usermod -aG for a one-week contractor.

Final listing should read like drwxrwsr-t+. The + means getfacl is required to see the full access list.

chmod 777 was rejected. That mode drops every boundary for every account on the box, including service accounts.
