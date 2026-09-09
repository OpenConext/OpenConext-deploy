monitoring-tests-docker
=========

Deploys the monitoring tests docker container and optionally extra check scripting per environment.

Requirements
------------

Access to the OpenConext-monitoring-tests container so it can be deployed. The health check scripts require a nagios instance running on the same host where the scripts can retrieve the information from.

Role Variables
--------------

Provide the health_checks variable to create the checks for your environments. Provide the environment name and the port in the monitoring where the scripts can retrieve this information. The scripts will be located at /opt/health_check_ENVIRONMENT/check.sh. The running of these scripts require python3. The following format for providing this information is required: 
health_checks:
  - name: env1
    port: 999
  - name: env2
    port: 9999 

License
--------------

These files are licensed under version 2.0 of the Apache License, as described in the file [LICENSE](LICENSE).

Support
--------------

* You can ask questions on the [OpenConext mailing list](https://openconext.org/get-involved/mailing-lists/) 
* Or you can join our [Slack Workspace](https://edu.nl/ocslk)
