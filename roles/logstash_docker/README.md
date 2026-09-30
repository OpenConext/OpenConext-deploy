logstash_docker
=========

This role deploys a logstash docker container

Requirements
------------

Requires some form of input, the filebeat role from OpenConext-deploy can be used for this. Requires a influxdb instance to write to, the OpenConext-deploy role influxdb_container can be used for this. The database must be named "log_logins" for this combination to work.

Role Variables
--------------

The following variables must be set:
 - logstash_memory_gb: (defaults to 4, can be set to 1 for development/test environments)
 - influx_stats_dbhost: (the host where influxdb runs on, if this runs in a container on the same host provide the name of the container.)
 - influxdb_stats_user: (user that can access the influxdb database)
 - influxdb_stats_password: (password of the user that can access the database, store this securely for example in a vault.)

License
--------------

These files are licensed under version 2.0 of the Apache License, as described in the file [LICENSE](LICENSE).

Support
--------------

* You can ask questions on the [OpenConext mailing list](https://openconext.org/get-involved/mailing-lists/) 
* Or you can join our [Slack Workspace](https://edu.nl/ocslk)
