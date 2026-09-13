I provisioned the lab account devuser with useradd -m -s /bin/bash so it received a home directory and a bash login shell.
passwd set the account password, and id showed uid 1001, gid 1001, and shell /bin/bash.
ls /home/devuser was denied from sindini, so ls -ld /home/devuser was used to prove the home directory exists and is owned by devuser.
groupadd created the developers group as gid 1002, and usermod -aG added devuser to that group.
usermod -G was also run to show it replaces supplementary groups instead of appending them.
I inspected /etc/passwd, /etc/shadow, and /etc/group so the UID, GID, hash location, home, shell, and group membership were documented.
nginx was not installed at first, so it was installed, and which systemctl returned /usr/bin/systemctl.
visudo was used to add one rule: devuser ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx.
As devuser, sudo systemctl restart nginx worked and sudo systemctl stop nginx was denied.
sudo -l showed only that one allowed command.
