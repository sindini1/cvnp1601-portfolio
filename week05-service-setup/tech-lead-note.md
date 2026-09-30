server-setup.sh installs nginx on a clean Ubuntu box, turns the service on for boot, starts it immediately, and then checks that the daemon is actually running.

The script refreshes apt so it does not grab a stale package list. It uses apt install -y because a setup script cannot answer a prompt. enable --now covers both states in one command: running now, and still running after a reboot.

I tested it the way another technician would use it. I purged nginx, ran autoremove, and used systemctl status to show the unit was gone or inactive. Then I ran sudo bash ~/server-setup.sh. The script printed SUCCESS. After it exited I ran is-active and is-enabled myself so the result was not only coming from the script.

That last check is the point. A package can install and still leave the service down, disabled, or masked. Without the verification block and exit 1, the next person thinks the demo box is ready when nginx is dead. The script is supposed to fail loudly, not look finished.
