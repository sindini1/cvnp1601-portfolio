# Week 9 Diagnosis

Ticket: a high-CPU nginx worker will not die. The trainee thinks it is a protected process and wants to reboot.

## 1. State
ps aux shows PID 5502 at 97.8% CPU. The USER column is www-data, not trainee. The command is nginx: worker process. kill 5502 failed with Operation not permitted. kill -9 5502 failed with the same message. Nothing was terminated.

## 2. Root cause
The trainee does not own the process. PID 5502 belongs to www-data. A normal user can only signal their own processes. SIGKILL does not override that. The kernel rejected both signals for the same reason: wrong user, not a protected process. A reboot is not required.

## 3. Remediation
Use sudo so the signal is sent as root. Still start with SIGTERM.

sudo kill 5502
sleep 3
ps aux | grep 5502

Only if it is still there:

sudo kill -9 5502

Do not reboot.

## 4. Verification
Check it two ways.

1. ps aux | grep 5502 should not show a live nginx worker. A leftover grep line is not the process.
2. ps aux --sort=-%cpu | head -5 should no longer show that www-data worker at the top. CPU should drop.

A rejected signal is about who is allowed to touch the process. It does not mean the process is unkillable. Treating a permission error as a protected system process wastes the incident.
