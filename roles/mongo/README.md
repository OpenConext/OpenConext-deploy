# Mongo installation
This role will install Mongo in either standalone mode, or in cluster mode. It is intended to be used in the OpenConext platform.

You need to set the role of your mongo hosts in the host_vars.

the key is `mongo_replication_role:` and it can have the values: "primary", "secondary" or arbiter.

Cluster certificates have to have an identical value for the OU, O or DC attribute, as described in the Mongo documentation.

Save the mongo ca.pem that is used for siging the cluster certifates as {{ environment_dir }}/secrets/mongo/mongoca.pem

Set the cluster certificate as variable mongo_cluster_cert in host_vars
Set the mongo_cluster_private_key variable encrypted in host_vars

Please review the official Mongo documentation for more information.

# Mongo deployment

To avoid surprisesyou can enable or disable cluster configuration with the boolean option mongo_configure_cluster. The role willonly initiate or reconfigure cluster if this is true (safest option is to use -e mongo_configure_cluster=true with your deployment when cluster configuration is necessary).
Another issue is the serial value, it is safest to set it to 1 in your playbook, if it is higher multiple mongo nodes can will be restarted at once and it can break your cluster. However when you want to intialise a new cluster you need to run the tasks parallel and serial needs to be as high as the amount of nodes. We handled this with a variable serial with the name serial_number in our playbook with a default 1. If cluster initialisation or reconfiguration is necessary use -e "serial_number=<AMOUNT_OF_CLUSTERMEMBERS>"


See also https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_strategies.html#setting-the-batch-size-with-serial


# Todo
- [x] Check mongo_replication_roles and give a clear fail message when not set
- [ ] Add option to change the already existing admin user, for now change the password manually and change it in the ansible config accordingly
- [x] Add the possibility for adding and removing cluster members
- [x] Add the possibility for a standalone mongo server
- [x] Cluster changes can be enabled or disabled
- [ ] Reconfigure cluster always reports changed
