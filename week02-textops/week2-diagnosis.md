# Week 2 Diagnosis

Ticket: trainee source-IP frequency report from /var/log/auth.log

## 1. State
awk '{print $11}' /var/log/auth.log > src-ips.txt worked. wc -l said 40 lines, so the extract landed. uniq -c src-ips.txt | sort -rn | head -5 also ran. The top lines are all count 1, and 10.0.0.5 shows up more than once in that short list instead of being combined. The raw log still has 10.0.0.5 several times. uniq is producing output. It is just not grouping the repeats.

## 2. Root cause
uniq only collapses lines that are next to each other. The IPs were written in log order, so 10.0.0.5 is mixed with other addresses. Each time it shows up alone it counts as 1. uniq is not broken and nothing deleted the extra hits before this step. The missing piece is sort.

## 3. Remediation
Sort first, then count.

sort src-ips.txt | uniq -c | sort -rn | head -5

If they want it in one shot from the log:

awk '{print $11}' /var/log/auth.log | sort | uniq -c | sort -rn | head -5

Do not trust $11 blindly either. Count fields on one Accepted line first. On this lab VM the auth log uses a full timestamp, so the source IP is $9 on the Accepted password line. Confirm the field on their file before handing the report over.

## 4. Verification
Check it two ways.

1. After the sorted pipeline, 10.0.0.5 should appear once with a count higher than 1.
2. Count that IP yourself and compare:
   grep -o "10.0.0.5" src-ips.txt | wc -l
   grep -c "10.0.0.5" /var/log/auth.log

Those two numbers should match the uniq count for that address. If they do, the report is safe to hand over.

If you ship the unsorted counts, repeated access from one source looks rare. Security would under-read the pattern.
