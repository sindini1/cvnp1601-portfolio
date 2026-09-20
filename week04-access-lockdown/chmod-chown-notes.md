# Task 2 notes

## Octal 750
I ran chmod 750 on ~/deploy.sh.
7 means the owner gets rwx.
5 means the group gets r-x.
0 means other gets nothing.
So I can edit and run the script, my group can run it, and nobody else can even read it.

## Before / after deploy.sh
touch made the file with my umask. umask is 0002 on this VM, so it started as `-rw-rw-r--`.
After chmod 750 it was `-rwxr-x---`.

## /project after chmod and chown
sudo chmod g+w /project gave the developers group write.
sudo chown $(whoami):developers /project made me the owner and kept the group as developers.
ls -ld showed `drwxrwxr-x 2 sindini developers`.
