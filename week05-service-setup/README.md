# Week 5 — Managing Software and Services

Ticket: CVNP1601-W5-005

## What I Can Do Now
This script automates nginx installation and service configuration on a new Ubuntu server so a junior sysadmin can produce a consistent, verified setup.

## AI Tool Use Statement
I used AI to draft writeup structure and to check that the script had the required header, WHY comments, and verification block. I ran the apt and systemctl commands on my lab VM, took the screenshots there, and I can explain the `systemctl is-active --quiet` check and the `exit 1` path without help.

## Lab notes

### Task 1 — remove vs purge
`apt remove` deletes the package binaries and leaves configuration files on disk. `apt purge` removes the package and those config files, which is what you want before a clean-state reinstall so old nginx settings do not come back.

### Task 2 — start vs enable
`systemctl start` only starts the service in this boot. `systemctl enable` only makes it start after future reboots. If you start nginx for a client demo and never enable it, the service dies at the next reboot and the site is down until someone logs in and starts it by hand.
