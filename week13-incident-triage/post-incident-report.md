# Post-Incident Report

Hostname: web13
Timestamp: 2026-11-23 23:40:00 CST
Ticket: CVNP1601-W13-013
Operator: sindini

## Incident summary
Three simultaneous symptoms on the lab VM: nginx failed to start after a config change, /var disk usage was elevated, and /var/www/html ownership was root instead of www-data. Business impact was critical because the web service was down. Triage order was service-affecting first (nginx), then health degradation (disk), then maintenance (permissions). One change at a time with verification between each.

## Triage order
1. Nginx service failure (customer-facing outage)
2. Disk pressure on /var (health degradation, risk of further failures)
3. Ownership on /var/www/html (maintenance, content not served correctly once nginx was up)

## Symptom 1: nginx failed

Root cause: A syntax error in /etc/nginx/sites-enabled/default (missing semicolon after a directive) caused nginx -t and the service start to fail.

Evidence checked first: systemctl status nginx showed failed; journalctl -u nginx captured the exact parse error before any restart.

Fix:
```
sudo nano /etc/nginx/sites-enabled/default   # restored missing semicolon
sudo nginx -t
sudo systemctl restart nginx
systemctl is-active nginx
```

Verification: nginx -t reported syntax ok; systemctl is-active nginx returned active; curl -I http://localhost returned HTTP/1.1 200 OK.

## Symptom 2: disk pressure on /var

Root cause: A 500 MB test fill file /var/log/testfill.img had been written, pushing /var above the attention threshold.

Evidence checked first: df -h /var showed available space; after the fill, usage rose and available dropped. du -sh /var/log/* identified the largest file. lsof confirmed no process held the file open before cleanup.

Fix:
```
sudo truncate -s 0 /var/log/testfill.img
```
(Truncate used instead of rm so the inode stays if any process still had it open; in this case lsof showed none.)

Verification: df -h /var showed the space returned; du no longer listed the large fill file.

## Symptom 3: permission failure on web content

Root cause: /var/www/html had been chowned to root:root, so the nginx worker (www-data) could not read the content.

Evidence checked first: curl -I http://localhost returned 403 after nginx was running; ls -la /var/www/html showed root:root.

Fix:
```
sudo chown -R www-data:www-data /var/www/html
```

Verification: ls -la showed www-data:www-data; curl -I returned HTTP/1.1 200 OK. Did not use chmod 777.

## Time to resolution
Approximately 25 minutes from first status check to final 200 OK, including journal capture, disk diagnosis, and ownership fix. One-change sequencing kept each verification attributable to a single action.

## Notes
Journal was captured before the successful nginx restart. Disk free-space was checked before the fill test. Ownership evidence was captured before and after chown. No secrets or broad permission changes were applied.
