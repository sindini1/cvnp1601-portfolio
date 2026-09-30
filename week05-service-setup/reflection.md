# Catacombs Act II reflection

The Silent Hall trial was the same job as server-setup.sh, just without root. I had to wake a user-level systemd unit with systemctl --user so the golem was both started now and enabled for the next session. Then I wrote torch.sh with a shebang and WHY comments instead of a pile of raw commands.

What went wrong at first was treating start as enough. A user service that is active but not enabled dies when the session ends, same way nginx dies after a reboot if you never enable it. I fixed that with enable --now on the user unit, then wrote the torch script and ran cast in the hall for CVNP1601-W05-DUNGEON-GOLEM.

That maps to a real ticket: prove the daemon is running, prove it survives the next start, and leave a commented script so the next person does not guess.
