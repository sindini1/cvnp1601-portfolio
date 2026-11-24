# Troubleshooting Narrative

What went wrong: nginx would not start after a config change, /var was filling, and the web root was owned by root so the worker could not read it. All three appeared at once.

What evidence I checked first: systemctl status and a journalctl capture for nginx, df -h /var for disk, and ls -la /var/www/html plus curl -I for the permission symptom. The journal gave the exact parse error before any restart.

What I tried: I fixed the nginx config and validated with nginx -t, then restarted. For disk I listed the largest files with du and checked open handles with lsof before truncating the fill file. For permissions I corrected ownership with chown rather than opening permissions with chmod 777.

What fixed it: restoring the missing semicolon, truncating the test fill file, and changing /var/www/html back to www-data:www-data. Each change was verified before the next.

How I verified the result: systemctl is-active nginx returned active and curl returned 200 after the config fix; df showed the space returned after truncate; ls -la showed the new ownership and a second curl returned 200 after the chown.

What the security or reliability impact was: Guessing the root cause or applying a broad chmod would have destroyed evidence and widened access. Capturing the journal first preserved the real failure context, and one-change sequencing made each verification attributable so the next technician can trust the report without re-testing everything.
