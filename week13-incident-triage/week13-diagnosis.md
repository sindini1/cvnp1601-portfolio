# Week 13 Break/Fix Diagnosis

## State
systemctl start nginx failed with an exit-code. systemctl status shows Active: failed (Result: exit-code) and the ExecStart process exited status=1/FAILURE. The journal lines show nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use) and still could not bind(). curl -I http://localhost returns HTTP/1.1 200 OK with Server: nginx/1.18.0. ss -tlnp | grep :80 shows LISTEN on 0.0.0.0:80 owned by nginx pid=1043. ps shows PID 1043, PPID 1, user www-data, started the previous day, command nginx: worker process.

## Root cause
An orphaned nginx worker from a previous kill -9 is still bound to port 80. The systemd unit is in a failed state because the new master process cannot bind the address, but the old worker process (PPID 1, not under systemd) continues to serve requests. The technician's theory that the 200 is a caching fluke is wrong; ss and ps show a live nginx process holding the port. The service manager reports failure because it does not control the process that is actually listening.

## Remediation
Identify and stop the orphaned process so the port is free, then start the unit cleanly:

```
ss -tlnp | grep :80
sudo kill 1043
sleep 2
sudo systemctl start nginx
systemctl is-active nginx
```

Do not simply restart again while the old process still holds the port; the bind will fail the same way.

## Verification
Two independent angles:

1. ss -tlnp | grep :80 should now show a different PID that is a child of the systemd nginx master, and systemctl is-active nginx should return active.
2. curl -I http://localhost should still return 200, and journalctl -u nginx -n 20 should show a clean start with no bind error.

## Security note
A service manager reporting failure is not proof that nothing is being served. The unit state reflects only what systemd controls. An orphaned process can continue to answer on the port after a kill -9, so the correct incident step is to check what is actually listening (ss -tlnp) and who owns it (ps) before deciding the service is down or that a 200 response is a fluke. Accepting the unit status alone would have led to the wrong conclusion and possibly an unnecessary outage window.
