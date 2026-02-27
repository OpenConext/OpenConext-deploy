Ansible-driven provisioning of the OpenConext platform.
==============================

# Introduction

This repository contains everything you need if you want to use Ansible for deployment of OpenConext applications, including the Stepup suite. It does currently not provide you with a step by step manual to get the whole OpenConext suite installed and working. With some Ansible experience and some work, you will be able to use this repository to deploy the OpenConext applications however. The document will provide information on how to do that.

If you want to get started with OpenConext, or with OpenConext development you can use our Docker compose based environment to get up and running quickly on a VM or your local laptop. Please refer to the devconf project that can be found here: https://github.com/OpenConext/OpenConext-devconf

# Contents of this repository

## Application roles
Every application has a seperate role to install it. The following roles can be found:

| name                  | function                       |
| ---                   | ---                            |
| engine                | Engineblock, the SAML proxy    |
| oidcng                | OpenID connect proxy           |
| myconext              | eduID                          |
| profile               | Profile page                   |
| manage                | Entity registration            |
| teams                 | Group membership app           |
| mujina                | Mujina IdP                     |
| voot                  | Voot membership API            |
| pdp                   | Policy Decicions API           |
| attribute-aggregation | Attribute aggregation API      |
| invite                | Invite based groups            |
| welcome               | Invite UI                      |
| dashboard             | IdP dashboard                  |
| lifecycle             | User lifecycle                 |
| stats                 | Statistics                 |
| monitoring-tests      | end2end monitoring app         |
| diyidp                | A SimpleSAMLphp based test IdP |
| stepupazuremfa        | Stepup AzureMFA GSSP           |
| stepuptiqr            | Stepup TIQR GSSP               |
| stepupwebauthn        | Stepup Webauthn GSSP           |
| stepupgateway         | Stepup SAML gateway            |
| stepupmiddleware      | Stepup middleware              |
| stepupra              | Stepup ra interface            |
| stepupselfservice     | Stepup selfservice interface   |

All these applications run in Docker. You can use the "docker" role to install docker and Traefik. The result is a Docker application server, with port 443 open. Applications are served by Traefik and recognized on basis of a Host: header. If you run a small installation, you can add a https certificate to Traefik and run a single node application server.

For a fully functioning environment you also need a MariaDB database server and a Mongo database server.

## Infra roles
This repository is used for deployment of SURFconext, and several roles that the SURFconext teams uses to provision our infrastructure are provided here as well. You can use them for your own infrastructure or use them as inspiration.
| name         | remarks                                                                      |
| ---          | ---                                                                          |
| bind         | DNS server for high availability. Very specific for SURFconext               |
| docker       | To deploy Docker and Traefik application servers                             |
| elk          | Not maintained Elasticsearch, Logstash and Kibana role. For inspiration only |
| haproxy      | Loadbalancer configuration. The role has its' own README                     |
| haproxy_mgnt | For red / blue deployments using haproxy                                     |
| iptables     | Manage your iptables based firewall                                          |
| keepalived   | VRRP config for HA between loadbalancers and database nodes                  |
| rsyslog      | For central logging and parsing login statistics for stats                   |
| galera       | Install multi master MariaDB database with galera. Runs on Rocky 9           |
| mongo        | Install a mongo cluster  (has its own README)                                |
| manage_provision_entities|Provision entities to Manage                                      |

# Setting up your environment
Many variables can be overridden to create a setup suitable for your needs. We will explain the setup here for one environment or for a multi-environment (OTAP for example) setup.

The setup descibed below should work, but when using ansible many paths lead to Rome. If you want to know more about variables and where to save them, this can be helpfull: https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable

## Inventory
You need an inventory file for your environment or multiple inventory files if you have multiple environments. An example can be found in environments/template

## Playbook
You can use the provision.yml script to deploy all infra and application roles. Every play has a tag so you can deploy your environment one application at a time by using the specific tag. You can also use your own playbooks if you prefer.

## First steps
Clone the repository with git.

```bash
cd yourdir
git clone https://github.com/OpenConext/OpenConext-deploy.git
```

Create ansible.cfg in your directory and add Openconext-deploy/roles to your roles_path

```bash
[defaults]
diff = true
roles_path = OpenConext-deploy/roles # Add your own roles directory if you want
```

## One environment
Copy the inventory, host and group files from environment/template to your directory and adjust them according to your preferences:

```bash
cp -R OpenConext-deploy/environments/template/* .
```

Edit your inventory file  
Edit group_var and host_var files if necessary  

Create an ansible vault in secrets and name it secrets.yml, an unencrypted example can be found in secrets/secret_example.yml  
More information about vaults: https://docs.ansible.com/projects/ansible/latest/vault_guide/index.html
The final setup will look like this:  

- group_vars/all.yml
- group_vars/\<GROUPNAME\>.yml
- secrets/secrets.yml
- host_vars/\<HOSTNAME\>/yml
- inventory
- Openconext-deploy/provision.yml
- Openconext-deploy/roles
- \<YOUROWNOPTIONALPLAYBOOKS\>.yml
- ansible.cfg

You can use the provision playbook now:

```bash
ansible-playbook OpenConext-deploy/provision.yml -i inventory -t <TAG> --ask-vault-password
```

## Multi-environment
Copy the inventory and group files from environment/template to your directory and adjust them according to your preferences:

```bash
mkdir <ENVIRONMENT> # test for example
cp -R OpenConext-deploy/environments/template/* <ENVIRONMENT>
# etc...
```
Edit your inventory files  
Edit group_var and host_var files if necessary  

For each environment create an ansible vault in secrets and name it secrets.yml, an unencrypted example can be found in secrets/secret_example.yml  
More information about vaults: https://docs.ansible.com/projects/ansible/latest/vault_guide/index.html

The final setup will look like this:  

- \<ENVIRONMENT\>/group_vars/all.yml
- \<ENVIRONMENT\>/group_vars/\<GROUPNAME\>.yml
- \<ENVIRONMENT\>/host_vars/\<HOSTNAME\>/yml
- \<ENVIRONMENT\>/inventory
- Openconext-deploy/provision.yml
- Openconext-deploy/roles
- \<YOUROWNOPTIONALPLAYBOOKS\>.yml
- ansible.cfg

You can use the provision playbook now:

```bash
ansible-playbook OpenConext-deploy/provision.yml -i <ENVIRONMENT>/inventory -t <TAG> --ask-vault-password
```

# License

These files are licensed under version 2.0 of the Apache License, as described in the file [LICENSE](LICENSE).

# Support

* You can ask questions on the [OpenConext mailing list](https://openconext.org/get-involved/mailing-lists/) 
* Or you can join our [Slack Workspace](https://edu.nl/ocslk)

