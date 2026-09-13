Created lab account devuser with useradd -m -s /bin/bash and set the password with passwd.
id showed uid 1001, gid 1001, and shell /bin/bash.
Home is /home/devuser.
Listing that folder as sindini was denied, so ls -ld was used to prove the directory exists and is owned by devuser.

groupadd created developers as gid 1002, and usermod -aG added devuser to the group.
usermod -G was run only to show that it replaces supplementary groups instead of appending them.

nginx was not installed, so it was installed, and which systemctl returned /usr/bin/systemctl.
visudo added one rule: devuser ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx.
sudo -l and sudo -u devuser sudo -l both listed only that command.
As devuser, systemctl restart nginx succeeded and systemctl stop nginx was denied.

The account, group, and sudo rule are still on the lab VM.
userdel and groupdel were not run so the evidence stays in place.
