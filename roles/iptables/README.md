Iptables role for OpenConext
==================================

This role installs iptables and ip6tables for the OpenConext nodes. 
Add rules is as easy as adding a list to the correct group variables. 
By placing the correct lists in the correct group variables, specific rules for specific (sets of) servers can be created. 

The following lists can be used;
* iptables_incoming
* iptables_incoming_lb 
* iptables_incoming_php
* iptables_incoming_java
* iptables_incoming_db_cluster
* iptables_incoming_db

A list looks like this:
```
iptables_incoming: 
  - name: Put a name here. It shows up as a comment in the resulting iptables file
  - source: Source ip address or range, can be omitted
  - destination: Destination ip address, can be omitted
  - protocol: Service protocol (udp or tcp). Can be omitted, defaults to tcp
  - port: Service port
```
Example:

Opening TCP port 22 for 192.168.86.0/24:
```
iptables_incoming:
  name: Port 22 is open for 192.168.86.0/24 to allow SSH sessions
  source: 192.168.86.0/24
  port: 22
````

The resulting iptables rule would be:
```
-A INPUT -p tcp -s 192.168.86.0/24 --dport 22 -j ACCEPT
```

Rules for ip6tables can be made as well. The corresponding variables are:
* ip6tables_incoming
* ip6tables_incoming_lb
* ip6tables_incoming_php
* ip6tables_incoming_java
* ip6tables_incoming_db_cluster
* ip6tables_incoming_db


