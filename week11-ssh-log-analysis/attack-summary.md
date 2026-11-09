# SSH Attack Summary

Total failed password attempts in the reviewed auth.log: 541.

Top source IPs by frequency:
- 192.168.1.50 (372)
- 10.0.0.99 (148)
- 172.16.4.2 (17)

The ranking came from grep "Failed password" /var/log/auth.log | awk '{print $11}' | sort | uniq -c | sort -rn | head -10 after field position was verified.

Recommended next step: review firewall policy and block or rate-limit the top two source IPs. Confirm whether PasswordAuthentication is still enabled on the SSH daemon.
