# Container Handoff — helpdesk-web

## Start command (exact)

```bash
docker pull nginx:1.25-alpine
docker volume create helpdesk-data
docker run -d \
  --name helpdesk-web \
  --restart unless-stopped \
  -p 8080:80 \
  -v helpdesk-data:/usr/share/nginx/html \
  nginx:1.25-alpine
```

## Verification URL

http://localhost:8080

Expected result is HTTP/1.1 200 OK from the default nginx page.

## Expected docker ps state

```
CONTAINER ID   IMAGE               STATUS         PORTS                  NAMES
xxxxxxxxxxxx   nginx:1.25-alpine   Up ...         0.0.0.0:8080->80/tcp   helpdesk-web
```

## Logs command

```bash
docker logs --tail 100 helpdesk-web
```

## Inspect commands

```bash
docker inspect helpdesk-web
docker inspect helpdesk-web --format '{{json .Mounts}}'
docker inspect helpdesk-web --format '{{json .HostConfig.PortBindings}}'
```

## Volume decision

Named volume helpdesk-data is mounted at /usr/share/nginx/html. Content written into the volume survives container removal and recreation. The volume is independent of the container lifecycle.

## Restart behavior

--restart unless-stopped keeps the container running across host reboots unless it was explicitly stopped. After docker restart helpdesk-web the service answers again on port 8080 and the volume is still there.

## Rollback / stop

```bash
docker stop helpdesk-web
docker start helpdesk-web
```

## Cleanup warning

Only after all evidence is captured:

```bash
docker rm -f helpdesk-web
```

Do not run docker volume rm helpdesk-data unless the data is intentionally disposable. Removing the volume destroys the persisted content.

## Troubleshooting table

| Symptom | First diagnostic command | Expected evidence / next action |
|---------|--------------------------|---------------------------------|
| Image pull denied | docker pull nginx:1.25-alpine | Auth or network error. Check registry credentials or proxy. |
| Port already allocated | ss -tlnp \| grep 8080 and docker ps -a | Another process or stopped container still holds 8080. Free the port or pick a different host port and document the change. |
| Container exits immediately | docker logs helpdesk-web and docker ps -a | Exit code and last log lines show the entrypoint failure. Fix the config or command and recreate. |
| curl connection refused | docker logs --tail 20 helpdesk-web then inspect PortBindings | Look at the listen address. If the process is only on 127.0.0.1, change the app config to 0.0.0.0 and recreate. |
| Data missing after recreation | docker volume ls and docker volume inspect helpdesk-data | Confirm the volume still exists and was re-mounted. If the volume was removed, the data is gone. |
