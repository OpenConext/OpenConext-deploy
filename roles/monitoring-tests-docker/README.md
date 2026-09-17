monitoring-tests-docker
=========

Deploys the monitoring tests docker container and optionally extra check scripting per environment.

Requirements
------------

Access to the OpenConext-monitoring-tests container so it can be deployed. The health check scripts require a nagios instance running on the same host where the scripts can retrieve the information from.

Role Variables
--------------

Provide the health_checks variable to create the checks for your environments. Provide the environment name and the ports for the monitoring, mujina sp and mujina idp containers. Any port that your infrastructure allows can be used here. The scripts will be located at /opt/health_check_ENV/check.sh. The running of these scripts require python3. The following format for providing this information is required: 

health_checks:
  - name: env1
    port: 1010
    port_idp: 1011
    port_sp: 1012
  - name: env2
    port: 1020
    port_idp: 1021
    port_sp: 1022

The following variables must be provided:
 - monitoring_tests.metadata_sp_url
 - monitoring_tests.metadata_idp_url
 - monitoring_tests.person_id
 - monitoring_tests.oidcng_client_id
 - monitoring_tests.oidcng_resource_server_id
 - mujina_idp.entity_id
 - base_domain
 - pdp.username

The following password must be provided as variables:
 - monitoring_tests_oidcng_client_secret
 - monitoring_tests_oidcng_resource_server_secret
 - pdp.password

This role assumes your ansible inventory structure is setup as followes:
├── Inventory (named env1)
│   ├── group_vars
│   ├── inventory.json / inventroy.yml
│   └── secrets
│       └── group_vars
└── OpenConext-Deploy
    └── roles
        ├── mujina_sp
        ├── mujina_idp
        └── monitoring-tests-docker

License
--------------

These files are licensed under version 2.0 of the Apache License, as described in the file [LICENSE](LICENSE).

Support
--------------

* You can ask questions on the [OpenConext mailing list](https://openconext.org/get-involved/mailing-lists/) 
* Or you can join our [Slack Workspace](https://edu.nl/ocslk)
