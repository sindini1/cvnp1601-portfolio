# Week 11 Diagnosis

Ticket: trainee says SSH brute force is small (42 attempts) and probably tapering off.

## 1. State
The trainee ran grep -c "Failed password" /var/log/auth.log and got 42. The ranked pipeline on the same file showed top counts of 18, 12, 9, and 3. ls -la /var/log/auth.log* listed auth.log at 8214 bytes dated Jul 21 09:12, auth.log.1 at 61802 bytes dated Jul 20, plus two compressed files from earlier in the month.

## 2. Root cause
The pipeline only read the current /var/log/auth.log. That file is small and recent. The rotated auth.log.1 and the .gz files hold the rest of the week's entries. Checking one file understates the total activity.

## 3. Remediation
Count across all available files first.

grep -c "Failed password" /var/log/auth.log /var/log/auth.log.1
zgrep -c "Failed password" /var/log/auth.log*.gz

Or pull the full window from the journal:

journalctl -u ssh --since "7 days ago" | grep -c "Failed password"

## 4. Verification
Two angles. Sum the separate file counts and compare against the single 42. Then run the journalctl version for the same window and check if the number is higher. A defensible report has to include every log source that still exists on the system. One pipeline against one current file is not enough to say the attack stopped.
