1. What went wrong or could have gone wrong?
A script that only runs apt install can finish while nginx is still stopped, disabled, or masked. Then the next reboot or the client demo has no web service. On the break-fix ticket, dpkg said ii and the trainee wanted to purge and reinstall. The real block was a masked unit. Purge would have wasted time and still left the mask in place.

2. What evidence did I check first?
dpkg -l nginx for the package state (ii after install, gone or not-installed after purge).
systemctl status nginx for the Loaded and Active lines.
systemctl is-enabled and is-active as separate checks.
The web02 transcript line Unit nginx.service is masked.

3. What did I try?
apt update, apt install -y nginx, then purge and autoremove to get a clean box.
start, enable, stop, and enable --now so I could see those states change one at a time.
Wrote server-setup.sh with a quiet is-active check and exit 1.
Ran the script only after the purge so I was not testing against an already-installed package.

4. What fixed it or what I would try next?
For my lab box the script was the fix: install, enable --now, then verify.
For the trainee ticket the first command is sudo systemctl unmask nginx, then enable --now again.
If unmask is not enough I would run systemctl status and journalctl -u nginx -e before I touch apt again.

5. How did I verify the result?
Clean-state proof: status after purge showed inactive or not-found.
Script output included the SUCCESS line.
Independent checks after the script: is-active printed active and is-enabled printed enabled.
For a masked unit I would also confirm Loaded: loaded and that /etc/systemd/system/nginx.service is not a symlink to /dev/null.

6. What was the security impact?
A web service that is installed but not running still changes what people think is exposed, and it fails the availability side of the same setup. A masked unit is an intentional stop. If you ignore that line and reinstall, you can miss that someone meant to keep the daemon off. The verification block plus exit 1 keeps a dead service from being handed off as ready.
