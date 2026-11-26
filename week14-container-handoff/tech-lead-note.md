# Technical Lead Note

Week 14 deployed the internal helpdesk web tool as container helpdesk-web from the pinned image nginx:1.25-alpine. Settings were explicit: name helpdesk-web, host port 8080 mapped to container port 80, named volume helpdesk-data mounted at /usr/share/nginx/html, and restart policy unless-stopped. The image tag is pinned so a future recreate pulls the same verified binary instead of whatever latest happens to point at.

After start and again after restart, curl -I http://localhost:8080 returned HTTP 200. docker inspect confirmed PortBindings and Mounts matched the intended configuration. The named volume survives container removal, so anything written under the document root will still be there after recreation.

Rollback is docker rm -f helpdesk-web followed by the same docker run line recorded in docker-run.txt. Cleanup warning: do not remove the volume with docker volume rm helpdesk-data unless the data is intentionally disposable. The volume is independent of the container lifecycle.

Remaining risk is that the current image only serves the default nginx page. If real application content is later dropped into the volume, ownership and permissions inside the volume need to be checked so the nginx worker can read the files. No secrets or credentials are present in this deployment.
