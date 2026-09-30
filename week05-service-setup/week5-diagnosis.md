# Week 5 Diagnosis

Ticket: trainee installed nginx on web02. dpkg looks fine. systemctl enable --now fails.

## 1. State
apt install finished and printed Setting up nginx. dpkg -l nginx shows `ii`, so the package is installed and the files are on disk.
enable --now did not work. The exact line is: Failed to enable unit: Unit nginx.service is masked.
status then shows Loaded: masked (Reason: Unit nginx.service is masked.) and Active: inactive (dead).
The package step worked. The service manager step did not. Nothing in the transcript shows a broken .deb or a half-installed package.

## 2. Root cause
nginx.service is masked. Masking is a systemd setting that points the unit at /dev/null so start and enable both refuse to run.
dpkg only answers "is the package installed." systemctl answers "will this unit run." Those are two different layers.
The install is not corrupted. Someone masked the unit on that box, or a leftover mask stayed after an earlier disable or purge. Reinstalling the package will not unmask the unit by itself.

## 3. Remediation
Unmask first. Do not purge and reinstall yet.

sudo systemctl unmask nginx

Then retry the original command:

sudo systemctl enable --now nginx

If you want to see why it was blocked, check for a symlink to /dev/null before you unmask:

ls -l /etc/systemd/system/nginx.service

A mask looks like that path pointing at /dev/null.

## 4. Verification
Check it two ways that do not depend on each other.

1. Service manager: `systemctl status nginx` should say Loaded: loaded, not masked. `systemctl is-enabled nginx` should print enabled. `systemctl is-active nginx` should print active.
2. Unit file: `ls -l /etc/systemd/system/nginx.service` should no longer be a symlink to /dev/null. After that, `systemctl cat nginx` should show a real unit file instead of an empty mask.

Do not treat a second apt install as proof. dpkg already said the package was fine. The bug was the masked unit, so the proof has to come from systemctl.

Reading the Loaded line matters more than wiping the package. Masked is an intentional "do not start this" state. A quiet mask can leave a public web server down after a demo while everyone argues about a "corrupt install" that never happened.
