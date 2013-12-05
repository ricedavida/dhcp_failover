dhcp_failover
=============
k-level DHCP failover scripts that work with keepalived

Author: David Rice <rice.davida@gmail.com>

The basic idea behind these scripts/configs is to create a multi-node keepalived cluster of DHCP servers.
Since DHCP is layer 2 and does not check IP addresses, it can cause conflicts when there are multiple 
DHCP servers running at the same time.  In addition to this problem, this solves the problem of synchronizing
files between the systems (which is handy in cases like dhcpd.leases, but can be used for other such purposes)

Setup: (each will need to be done on each server)
   1. Install keepalived
   2. Replace the keepalived.conf file with the one provided. (modifying the file as is necessary)
   3. Move the dhcp_stop.sh dhcp_start.sh scripts to the keepalived folder (same level as keepalived.conf)
   4. Set the requirements in syncfiles.conf and move it someplace onto each system
   5. Move the syncdhcp.pl perl script onto each system

Running the script:
   1. The keepalived stuff will be handled by the syncdhcp.pl (as long as the service field is set to keepalived)
   2. syncdhcp.pl was designed to be run as a cronjob (originally set for 5 minutes, but can be adjusted)

Suggestion: First use of syncdhcp.pl should be manual so that methodology is understood.



OLD CHANGE LOG:
===============
commit 3112052aac133812cb54b9055efd3cebb35a57e2
Author: David Rice <riceda195@gmail.com>
Date:   Tue Nov 19 15:41:28 2013 -0500

    fixed a bug in the syncdhcp.pl script and several bugs in the template file for directory

commit 53a30becbda032bfa940517afd00710de3a728f7
Author: David Rice <riceda195@gmail.com>
Date:   Fri Oct 11 10:29:13 2013 -0400

    there were a few errors, all fixed now

commit 07a2964b35619f0c241ac437dc645e2fed4ff9e5
Author: David Rice <riceda195@gmail.com>
Date:   Fri Oct 11 10:24:51 2013 -0400

    updated the syncdhcp.pl file to give it more versatility

commit c8fc91d6c4ffd9d19390680dbcc5510f5fff4a46
Author: David Rice <riceda195@gmail.com>
Date:   Thu Oct 10 17:10:08 2013 -0400

    added a tool to sync files accross a keepalived cluster and added a few modified PacketFence files

