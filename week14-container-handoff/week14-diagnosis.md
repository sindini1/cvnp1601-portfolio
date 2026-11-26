# Week 14 Break/Fix Diagnosis

## State

docker run created the container and returned an ID. docker ps shows it Up for 14 minutes with the mapping 0.0.0.0:8080->80/tcp. curl -I http://localhost:8080 fails with connection refused. The logs say the server is listening on 127.0.0.1:80. docker inspect confirms the PortBindings field has host port 8080 mapped to container port 80. Everything Docker reports looks correct except the listen address in the application log.

## Root cause

The process inside the container is only listening on 127.0.0.1:80. That is the container's loopback interface. Docker forwards traffic from the host's 8080 into the container on port 80, but only if something is actually listening on a non-loopback address inside the container (normally 0.0.0.0:80). Because the app bound to loopback only, connections that arrive through the Docker proxy get refused. The teammate's idea that the firewall or Docker networking is broken is wrong. The mapping and the container state are fine. The application never accepted external connections.

## Remediation

Change the application so it listens on 0.0.0.0 instead of 127.0.0.1, then recreate the container. A simple restart will not change a hard-coded listen address. Exact steps depend on how the image is configured (env var, config file, or flag). Example pattern:

```bash
docker rm -f reportgen-web
docker run -d --name reportgen-web --restart unless-stopped \
  -p 8080:80 \
  -e LISTEN_ADDR=0.0.0.0 \
  registry.local/reportgen:2.3
```

Use whatever configuration method the image actually supports. After the change the container must be recreated.

## Verification

Confirm from two independent angles that the service is reachable from outside the container:

1. From the host: curl -I http://localhost:8080 must return HTTP headers instead of connection refused. Optionally check ss -tlnp | grep 8080 to see Docker's proxy listening.
2. From the logs: docker logs --tail 20 reportgen-web should show a listen line on 0.0.0.0:80 (or any non-loopback address), and the PortBindings field in inspect should still show the expected mapping.

A successful curl from the host is the only real proof that traffic is crossing the published port. Checking reachability only from a shell inside the container would miss the original problem.
