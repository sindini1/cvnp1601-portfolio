1. What went wrong or could have gone wrong?
Disabling password login before the key worked would have locked me out. Enabling ufw before allowing ssh would have done the same. The trainee ticket is the quieter version. .ssh and authorized_keys were already correct, but key login still failed. auth.log said bad ownership or modes for /home/student.

2. What evidence did I check first?
I read the transcript in order. ssh -v offered the key and was refused. ls -la showed 700 on .ssh and 600 on authorized_keys, so the checklist files were fine. The auth.log line named /home/student, not the key file.

3. What did I try?
On my VM I generated an ed25519 key, installed the public key, and tested key login in a second session before I touched sshd_config. I backed up the config, set PasswordAuthentication no and PubkeyAuthentication yes, reloaded ssh, and checked sshd -T. I allowed ssh in ufw before enable. I set harden.sh and .ssh to 700 and authorized_keys to 600.

4. What fixed it or what I would try next?
For the trainee, chmod go-w /home/student, and chown student:student /home/student if the owner is wrong. Do not regenerate the key. On my own run, the order was the fix: key test, then password disable, then firewall.

5. How did I verify the result?
sshd -T showed passwordauthentication no and pubkeyauthentication yes. A second SSH session still logged in with the key. ufw status verbose showed active with SSH allowed. ls -la showed 700, 700, and 600. For the home-directory case, ls -ld /home/student plus a new ssh -v would confirm the refusal is gone.

6. What was the security impact?
Password SSH is a brute-force target, so turning it off matters. A false lockout is the other risk. If you only check the two checklist files, you can miss a writable home directory and think the key is dead. The daemon log already named the bad path.
