# Mongo installation
This role will install Mongo in either standalone mode, or in cluster mode. It is intended to be used in the OpenConext platform.

You need to set the role of your mongo hosts in the host_vars.

the key is `mongo_replication_role:` and it can have the values: "primary", "secondary" or arbiter.

Cluster certificates have to have an identical value for the OU, O or DC attribute, as described in the Mongo documentation.

Save the mongo ca.pem that is used for siging the cluster certifates as {{ environment_dir }}/secrets/mongo/mongoca.pem

Set the cluster certificate as variable mongo_cluster_cert in host_vars
Set the mongo_cluster_private_key variable encrypted in host_vars

Please review the official Mongo documentation for more information.

# Todo
- [x] Check mongo_replication_roles and give a clear fail message when not set
- [ ] Add option to change the already existing admin user, for now change the password manually and change it in the ansible config accordingly
- [ ] Add the possibility for adding and removing cluster members
- [x] Add the possibility for a standalone mongo server
- [ ] Cluster config does not work with serial 1 in the play but for mongo config changes you do want serial 1, split up the role?
