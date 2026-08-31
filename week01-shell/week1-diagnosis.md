# Week 1 Diagnosis

## 1. State
First command worked. They grepped errors into incident.txt and wc -l said 215 lines. Second command ran too, they grepped critical into the same file and wc -l said 3 lines. The file is still there. The 215 lines are just gone. The transcript does not show the log getting rotated or deleted.

## 2. Root cause
They used > twice. > overwrites the file every time. The critical search wiped the error lines and put 3 new lines in their place. It is not log rotation. They overwrote their own evidence.

## 3. Remediation
Do the error search first with >, then add critical with >>.

grep -i "error" syslog > ~/incident.txt
grep -i "critical" syslog >> ~/incident.txt

If the 215 lines are already gone, run the error grep again with > to recapture them, then append critical. Do not hit > on a file that already has stuff you need.

## 4. Verification
Check it two ways.

wc -l ~/incident.txt
grep -i "error" ~/incident.txt | wc -l
grep -i "critical" ~/incident.txt | wc -l

The total should be close to errors plus criticals. Also run ls -l ~/incident.txt and make sure the file got bigger after the append, not smaller.

If you wipe evidence mid-ticket you cannot prove what you saw and the next person is working off the wrong file.

