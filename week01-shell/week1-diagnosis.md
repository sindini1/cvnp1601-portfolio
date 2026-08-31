# Week 1 Diagnosis

## 1. State
The first grep into incident.txt worked. wc -l showed 215 error lines. The second grep also ran, but wc -l then showed only 3 lines. The file still exists. The 215 lines are gone. Nothing in the transcript shows syslog shrinking or a rotate happening.

## 2. Root cause
The trainee used > both times. > overwrites the file. The critical search replaced the error evidence instead of adding to it. This is not log rotation.

## 3. Remediation
Keep the first capture. Append the second search.

grep -i "error" syslog > ~/incident.txt
grep -i "critical" syslog >> ~/incident.txt

If the 215 lines are already gone, recapture errors first with >, then append critical with >>. Do not use > on a file that already has evidence you still need.

## 4. Verification
Check the file two ways:
wc -l ~/incident.txt
grep -i "error" ~/incident.txt | wc -l
grep -i "critical" ~/incident.txt | wc -l

The total line count should be about error hits plus critical hits. Also run ls -l ~/incident.txt and confirm the timestamp and size grew after the append, not shrank.

Losing collected evidence during an incident is bad because you cannot prove what you saw, you may miss the original error pattern, and you can send the next tech down the wrong path.
