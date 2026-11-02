1. What went wrong or could have gone wrong?
A script that only runs apt install can finish while nginx is still stopped, disabled, or masked. The next reboot or the client demo then has no web service. On the break-fix ticket, dpkg said the package was installed and the trainee wanted to purge and reinstall. The real block was a masked unit. A purge would have wasted time and still left the mask in place.

2. What evidence did I check first?
I started with dpkg -l nginx so I could see the package state before I touched the service. After the install the listing showed ii, which means the package was present. After the purge it no longer showed an installed package. I then ran systemctl status nginx and read the Loaded and Active lines, because those two lines are different facts. is-enabled and is-active were separate checks on purpose. On the web02 ticket the status line that mattered was Unit nginx.service is masked. That is a systemd decision, not a missing package.

3. What did I try?
I ran apt update, then apt install -y nginx, and confirmed the service came up. To prove a clean box I purged nginx and ran apt autoremove so leftover dependencies were gone. I then walked the lifecycle one state at a time: start, enable, stop, and enable --now, and I captured each transition. After that I wrote server-setup.sh so the same install, enable --now, and quiet is-active check would repeat. I only ran the script after the purge, so the success was not leftover from a package that was already there.

4. What fixed it or what I would try next?
On my lab box the script was the fix. It installed nginx, enabled it for boot and started it, then verified it was active before it printed success. On the trainee ticket the first command is sudo systemctl unmask nginx, then sudo systemctl enable --now nginx. If that is not enough I would read systemctl status nginx and journalctl -u nginx -e before I touch apt again, because a mask is not a broken package.

5. How did I verify the result?
After the purge, systemctl status nginx showed the unit inactive or not found, which is the clean-state proof. When I ran the script, the output included the SUCCESS line from the verification block. After the script finished I ran the checks again outside the script. systemctl is-active nginx printed active, and systemctl is-enabled nginx printed enabled. Those two answers are independent of the script's own echo. For a masked unit I would also confirm the Loaded line says loaded, and that /etc/systemd/system/nginx.service is not a symlink to /dev/null.

6. What was the security or reliability impact?
A web service that is installed but not running still changes what people think is exposed, and it fails the availability side of the same setup. A masked unit is an intentional stop. If you ignore that line and reinstall, you can miss that someone meant to keep the daemon off. The verification block plus exit 1 keeps a dead service from being handed off as ready.
