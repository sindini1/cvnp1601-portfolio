# Access lockdown summary

/project needed three different fixes. I did not use chmod 777.

I started with ls -ld. Then chmod +t for the sticky bit. alice made alice-file.txt and bob's rm printed Operation not permitted. The file was still there.

chmod g+s set SGID. before-sgid.txt kept alice's primary group. after-sgid.txt came out as developers.

setfacl -m u:carlos:r-x gave Carlos read and enter without putting him in developers. ls -ld picked up a `+`. getfacl showed `user:carlos:r-x`. setfacl -d -m g:developers:rw set the default group ACL, and acl-test.txt inherited it. setfacl -x u:carlos took Carlos back off.

chmod 750 on ~/deploy.sh made it owner rwx, group r-x, other none. chown $(whoami):developers made me the owner and left the group as developers. umask on this VM is 0002, so new files start at 664 and new dirs start at 775.
