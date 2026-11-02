# Week 10 Diagnosis

Ticket: ping to 8.8.8.8 times out. The trainee says routing cannot be the problem because two default routes exist.

## 1. State
ip route show lists two defaults on eth0. One is default via 10.0.2.1 proto dhcp metric 100. The other is default via 10.0.2.254 metric 50. The local subnet 10.0.2.0/24 is present. ping -c 4 8.8.8.8 sent 4 packets and received 0. Packet loss was 100%. SSH to the box still works. The interface is up. The table is not empty.

## 2. Root cause
A default route line is not proof that route is the one in use. When two defaults exist, the kernel picks the lower metric. Metric 50 beats metric 100, so traffic for 8.8.8.8 goes via 10.0.2.254, not via the DHCP gateway 10.0.2.1. 10.0.2.254 is the wrong next hop. That is why the ping times out even though a default exists. This is not a firewall or a DNS problem. DNS was never tested. The failure is at the IP layer.

## 3. Remediation
Delete the preferred bad route. Leave the DHCP one.

sudo ip route del default via 10.0.2.254

Do not add another default. Do not reboot. Do not touch DNS or the firewall first.

## 4. Verification
Check it two ways.

1. ip route show should list one default, via 10.0.2.1, and the 10.0.2.254 line should be gone.
2. ping -c 4 8.8.8.8 should get replies. 0% loss is the second proof. A route line alone is not enough.

A route entry in the table is not the same as the route the kernel is using. Two defaults mean you have to read the metric before you trust the table. That is the same mistake as trusting a firewall rule because it appears in a file.
