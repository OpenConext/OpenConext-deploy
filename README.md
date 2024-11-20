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

# Environment specific variables
Many variables can be overridden to create a setup suitable for your needs. The environment should be placed in the directory environments_external. 

A script is available to provision a new environment. It will create a new environment directory under environments-external/ and it will create all necessary passwords and (self-signed) certificates. Replace <environment> with the name of the target. Replace <domain> with the domain of the target.


```
/prep-env <environment> <domain>
```
Then run
```
cp environments-external/<environment>/host_vars/template.yml environments-external/<environment>/host_vars/<target_ip>.yml
```
(where <target_ip> is the ip address or hostname of your target machine, whatever is set in your inventory file)

Change in environments-external/<environment>/inventory:
Change all references from %target_host% to <target_ip>

```
Please note that this has not been tested in quite a while. You will need a lot of manual work to get this environment working
```


# Playbooks, tags and the provision wrapper script

Two playbooks exist in this repository: provision.yml and playbook_haproxy.yml. The latter can be used to do red/blue deployments if you also use our haproxy role.
The main playbook is provision.yml. It contains series of plays to install every role on the right node. All roles are tagged, so you can use the [Ansible tag mechanism](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html) to deploy a specific role. 

If you would like to deploy manage to your test environment, you would run:
```
ansible-playbook -i environments-external/test/inventory --tags manage -u THE_REMOTE_SSH_USER_WITH_SUDO_PERMISSIONS
```

A wrapper script which enables you to use your own roles can be used as well. That is documented here: https://github.com/OpenConext/OpenConext-deploy/wiki/Add-your-own-roles-and-playbooks 

# License

These files are licensed under version 2.0 of the Apache License, as described in the file [LICENSE](LICENSE).

# Support

* You can ask questions on the [OpenConext mailing list](https://openconext.org/get-involved/mailing-lists/) 
* Or you can join our [Slack Workspace](https://edu.nl/ocslk)

