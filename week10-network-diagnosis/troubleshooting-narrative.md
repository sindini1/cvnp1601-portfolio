1. What went wrong?
The server accepted SSH from the lab network and could not reach external IPs or hostnames. On the trainee ticket the table had two default routes and ping to 8.8.8.8 timed out. The trainee treated the presence of a default as proof that routing was fine.

2. What evidence did I check first?
I captured ip addr, ip route, and ss -tlnp to a timestamped file before any change. Then I split the layers. ip addr showed whether the interface was up. ip route showed whether a default existed. ping -c 4 8.8.8.8 tested raw IP. ping -c 4 google.com tested DNS. ss -tlnp showed whether SSH was listening on 22.

3. What did I try?
I read the route table before I added or deleted anything. If the default was missing I added it with sudo ip route add default via the lab gateway. On the trainee ticket the first move is sudo ip route del default via 10.0.2.254, because that line has metric 50 and wins over the DHCP gateway at metric 100.

4. What fixed it?
Restoring the correct default route. On the lab that is the gateway for the VM network. On the trainee box that is removing the lower-metric bad gateway so the DHCP route via 10.0.2.1 is the one in use. ip route add is a live fix only. It does not survive a reboot.

5. How did I verify the result?
ip route show after the change listed the correct default. ping -c 4 8.8.8.8 returned replies. ping -c 4 google.com returned replies, which means DNS was also working. The post-fix capture file has the same three commands as the pre-change file, so the before and after can be compared. ss -tlnp still showed port 22.

6. What was the security or reliability impact?
An undocumented route change is hard to audit and can send traffic to the wrong next hop. Two defaults are worse than none, because the table looks fine and the kernel is using the bad one. Connection refused means nothing is listening. Connection timed out means the packet left and nothing came back. Those are different layers. A live ip route add that is not in netplan will vanish on reboot and the outage will return.
