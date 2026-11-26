# Troubleshooting Narrative

What went wrong or could have gone wrong: a container can show Up in docker ps while the process inside is only listening on 127.0.0.1, so curl from the host gets connection refused. The same class of problem also shows up as a port already allocated error if something else is still holding 8080, or as an immediate exit if the image entrypoint fails.

What evidence I checked first: docker ps for the runtime state, the exact listen address in docker logs, and the PortBindings field from docker inspect. Those three together show whether Docker's mapping is correct and whether the process is actually accepting connections on a non-loopback address.

What I tried: confirming the mapping with inspect, reading the logs line that reported the listen address, and testing reachability with curl from the host instead of from inside the container. For the break/fix case the root cause was the application binding only to 127.0.0.1:80.

What fixed it: changing the application configuration so it listens on 0.0.0.0 and then recreating the container. A restart alone does not change a hard-coded listen address.

How I verified the result: curl from the host returned HTTP headers, and the logs showed a listen line on a non-loopback address. Relying only on docker ps or inspect would have left the original defect in place.

What the security or reliability impact was: an undocumented or mis-bound service can look healthy to operators while staying unreachable to users, which delays incident response. Explicit image tags, named volumes, and a short handoff that records the listen expectation reduce the chance the next person repeats the same silent failure.
