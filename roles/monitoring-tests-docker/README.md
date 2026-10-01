monitoring-tests-docker
=========

Deploys the monitoring tests docker container and optionally extra check scripting per environment.

Requirements
------------

Access to the OpenConext-monitoring-tests container so it can be deployed.
The health check scripts require a nagios instance running on the same host where the scripts can retrieve the information from.

This role has been tested with the monitoring-tests container version 9.1.0 and mujina version 10.0.1.
Older versions of these containers have issues which prevent these from working together. Use the listed or newer versions of these containers.

Role Variables
--------------

Provide the health_checks variable to create the checks for your environments.
Provide the environment name and the ports for the monitoring, mujina sp and mujina idp containers.
Any port that your infrastructure allows can be used here. The scripts will be located at /opt/health_check_ENV/check.sh.
The running of these scripts require python3. The following format for providing this information is required:

health_checks:
  - name: env1
  - name: env2

See this roles defaults/main.yml comments for all the required variables for the host(s) this role runs on.
Make sure your secrets are stored in a safe manner and not in plain text. The following vars are required within the set health_checks environments:
 - monitoring_tests_mujina_sp_port
 - monitoring_tests_mujina_idp_port

This role also runs the mujina-sp and mujina-idp roles based on the vars in the health_checks environments.
Check these roles for their own requirements for running them.

This role assumes your ansible inventory structure is setup as followes:
├── Inventory (containing the host that runs the tests)
│   ├── group_vars
│   ├── inventory.json / inventroy.yml
├── Inventory (named env1)
│   ├── group_vars
│   ├── inventory.json / inventroy.yml
│   └── secrets (looks in this directory for .yml files with vault secrets)
│       └── vault.yml
├── Inventory (named env2)
│   ├── group_vars
│   ├── inventory.json / inventroy.yml
│   └── secrets (looks in this directory for .yml files with vault secrets)
│       └── vault.yml
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
