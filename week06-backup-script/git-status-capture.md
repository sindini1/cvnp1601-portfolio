# Git status capture

After the script was written and staged, before the first commit:

```
$ git status
On branch master
Changes to be committed:
  new file:   backup_etc.sh
```

After the first commit, before the verification-line edit:

```
$ git status
nothing to commit, working tree clean
```

After the second edit and add:

```
$ git status
On branch master
Changes to be committed:
  modified:   backup_etc.sh
```

git log --oneline after both commits showed two entries: the logging script, then the archive-path verification line. A clean working tree after commit is the proof the snapshot landed. A staged file before commit is the proof the change was actually included, not left untracked.
