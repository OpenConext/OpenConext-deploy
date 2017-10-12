# Introduction
This role will install Mongo in either standalone mode, or in cluster mode. It is intended to be used in the OpenConext platform.

# Default minimal installation
The default installation will install a mongo instance on a single host, without any TLS settings. In order to prepare your environment for this installation, you need the following settings:

* Add the variable the following host_var for the host where the Mongo server should be installed:
```
mongo_primary: True
```
* Add this group to your inventory:
```
[mongod_primary]
```
# Cluster installation
The cluster installation is intended to have at two mongo hosts and one arbiter node to determine a majority in case of failure of one of the hosts. In order to deploy a cluster, you need the following changes in your environment:

* Add the following switch in your group_vars:
mongo_cluster: true

* Make sure the following groups exist in your inventory:
```
[mongo_servers]
Add all Mongo servers to this group

[mongod_primary]
Add your primary Mongo server to this group

[mongod_slaves]
Add one or more Mongo slaves to this group

[mongod_arbiters]
Add the Mongo arbiter node to this group
```

After deploying the Mongo role you should have a working Mongo cluster

# TLS
In order to secure the traffic between the cluster nodes, and between the clients and the Mongo cluster can be secured using TLS. The method to distribute the keys and certificates assumes the presence of a TLS root certificate authority, which is also used for the Galera role and the TLS certificates used to secure the traffic between the loadbalancer and the webserverbackends.

The manual below, and the role, assumes that only one key and certificate is used for all nodes in the cluster, and that a wildcard domain in the form of *.mongo.yourdomain.tld is used

## Create DNS entries and add the DNS names to your host_vars
Since this role assumes you have valid DNS names for your Mongo nodes, and a wildcard certificate is used in the form of *.mongo.yourdomain.tld you need to add these hostname to the DNS and as a variable in your host_vars:

* Add the following dns entries, preferably with CNAMES pointing to the right host
```
db1.mongo.yourdomain.tld 
db2.mongo.yourdomain.tld
dbx.mongo.yourdomain.tld
```

* Add the following variables to the individual host_vars (in environments/your_env/host_vars/ansible_inventory_hostname.yml
```
mongo_hostname: dbx.mongo.yourdomain.tld
```

## Create a root CA key and certificate 
If you don't have one yet, or you want a seperate root CA for mongo, create a root CA key and certificate

Create the key:
```bash
openssl genrsa -out /path/to/ca/ca.key 2048
```

Create the certificate
```bash
openssl req -x509 -new -nodes -key /path/to/ca/ca.key -sha256 -days 365000 -out /path/to/ca/ca.pem
```
## Create the TLS keys and certificates

To create the key and CSR, enter the following commands (assuming your domain is yourdomain.tld)
```bash
openssl req -newkey rsa:2048 -days 365000 -nodes -keyout mongo.yourdomain.tld.key -out mongo.yourdomain.tld.csr
```
Make sure you use *.mongo.yourdomain.tld as Common Name

* Create and sign a certificate using your own root CA, assumed to be located in /path/to/ca/ca.key. The root CA certificate is assumed to be in /path/to/ca/ca.pem

```bash
openssl x509 -req -in mongo.yourdomain.tld.csr -days 365000 -CA /path/to/ca/ca.pem -CAkey /path/to/ca/ca.key -out mongoyourdomain.tld.crt
```

You now have a key and a certificate that you can use. These, and the root CA certificate have to be put in the right locations. 

Store the key in your secrets yml file under the variable:
```
mongo_tls_key:
```
In the same manner as the https_star_private_key: in environments/vm/secrets/vm.yml

Copy the certificate to your environment directory, in your_env/files/certs/mongo/mongo.yourdomain.tld.crt, where yourdomain.tld is the same as your {{ base_domain }}
```bash
cp mongoyourdomain.tld.crt your_env/files/certs/mongo/
```
Copy the CA root certificate to your environments directory as well: 
```bash
cp /path/to/ca/ca.pem your_env/files/certs/mongo/mongo.yourdomain.tld_ca.pem
```

You can now deploy the mongo role, and it will add put the keys and certificates in the right location

The role "manage" will add your CA root certificate to the local certificate store as well
