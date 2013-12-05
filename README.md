dhcp_failover
=============

k-level DHCP failover scripts that work with keepalived

The basic idea behind these scripts/configs is to create a multi-node keepalived cluster of DHCP servers.

Since DHCP is layer 2 and does not check IP addresses, it can cause conflicts when there are multiple 
DHCP servers running at the same time.  In addition to this problem, this solves the problem of synchronizing
files between the systems (which is handy in cases like dhcpd.leases, but can be used for other such purposes)
