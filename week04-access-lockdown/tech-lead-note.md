/project is a shared developers directory. I did not use chmod 777. I applied three separate controls.

Sticky bit: chmod +t. Directory write normally lets anyone in the group delete files they do not own. After the bit was set, bob's rm on alice-file.txt printed Operation not permitted and the file was still listed. That is the proof it worked.

SGID: chmod g+s. New files usually take the creator's primary group. before-sgid.txt stayed group alice. after-sgid.txt came out group developers. ls -ld showed s in the group execute slot.

ACL: setfacl -m u:carlos:r-x /project. Carlos needed read for a week and should not join developers. getfacl showed user:carlos:r-x. acl-test.txt inherited the default developers ACL. setfacl -x removed Carlos. ls -ld showed a trailing +.

Remaining cleanup: the default ACL is still on /project, which is why the + stayed after Carlos was removed. If the contractor work is done, that default entry can come off with setfacl too. 777 is still the wrong answer because it gives every account on the box the same write and delete rights as the team.
