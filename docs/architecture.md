# Architecture

The lab uses a VirtualBox host-only network (`192.168.56.0/24`) with no Internet path from the domain controller. DC01 provides DNS, LDAP, Kerberos and AD DS for `lab.local`; WS01 and WS02 are domain members; Kali is the assessment host.

The default footprint is 16 GB RAM. Remove WS02 from the `Vagrantfile` when the host has only about 12 GB available.
