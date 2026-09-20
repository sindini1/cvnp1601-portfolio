# Task 2 notes

## Octal 750
chmod 750 ~/deploy.sh
- 7 = 4+2+1 = rwx for the owner
- 5 = 4+0+1 = r-x for the group
- 0 = --- for other
Owner can read, write, and run the script. Group can read and run it. Other cannot read it, so credentials inside the script stay off the rest of the system.

## Before / after deploy.sh
touch creates the file with the umask applied. On this VM umask is 0002, so a new file starts at 664 (rw-rw-r--), not 644.
After chmod 750 the string should be -rwxr-x---.

## /project after chmod and chown
sudo chmod g+w /project adds group write. That is the w in the group triplet.
sudo chown $(whoami):developers /project sets owner to sindini and group to developers.
ls -ld /project should show sindini developers and group write. Sticky bit and SGID are still off at this point.
