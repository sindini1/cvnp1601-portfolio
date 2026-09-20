/project is shared with developers. I added three extra controls instead of opening it with 777.

Sticky bit: chmod +t. Only the file owner or root can delete files in there. bob could not remove alice's file.

SGID: chmod g+s. New files inherit group developers instead of whoever created them.

ACL: setfacl -m u:carlos:r-x /project. Carlos gets read and enter for now. He is not in developers. Take it back with setfacl -x u:carlos /project when the week is over.

ls -ld ended at `drwxrwsr-t+`. The `+` means you have to run getfacl to see the full list.

777 would have given every account on the box the same write and delete rights as the team.
