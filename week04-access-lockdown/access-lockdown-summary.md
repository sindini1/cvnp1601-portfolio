The shared /project directory had three separate problems, so three separate controls were applied. chmod 777 was not used.

ls -ld showed the starting mode on /project. chmod +t set the sticky bit. After that, alice created alice-file.txt and bob's rm printed Operation not permitted. The file was still there.

chmod g+s set SGID on /project. before-sgid.txt kept alice's primary group. after-sgid.txt inherited developers. ls -ld showed s in the group execute slot and t in the other execute slot.

setfacl -m u:carlos:r-x /project granted the contractor read and execute without adding him to developers. ls -ld then showed a trailing +. getfacl listed user:carlos:r-x and a mask that did not cap it. setfacl -d -m g:developers:rw /project set the default group entry. A new file inside inherited that ACL. setfacl -x u:carlos /project removed the named user entry.

chmod 750 was used on ~/deploy.sh so owner has rwx, group has r-x, and other has nothing. chown root:developers set directory ownership. umask was recorded and subtracted from the 666/777 bases to explain new file and directory modes.
