# Mongo installation
This role will install Mongo in either standalone mode, or in cluster mode. It is intended to be used in the OpenConext platform.

You need to set the role of your mongo hosts in the host_vars.

the key is `mongo_replication_role:` and it can have the values: "primary", "secondary" or arbiter.

Please review the official Mongo documentation for more information.
