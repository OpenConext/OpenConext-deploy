influxdb_docker
=========

This role deploys a influxdb docker container

Requirements
------------

Requires a logstash instance to fill the influxdb. The influxdb instance is used by the stats container. The OpenConext-deploy roles "logstash_docker" and "stats" can provide this.

Role Variables
--------------

The following variables must be set:
 - influxdb_host (defaults to localhost, is used for setting user permissions within the database)
 - influx_stats_db (name of the database to be created)
 - influxdb_admin_user (admin user for influxdb)
 - influxdb_admin_password (admin password for influxdb, make sure this is securely stored for example in a vault)
 - influxdb_stats_user (user for accessing the database)
 - influxdb_stats_password (user password for influxdb, make sure this is securely stored for example in a vault)


License
--------------

These files are licensed under version 2.0 of the Apache License, as described in the file [LICENSE](LICENSE).

Support
--------------

* You can ask questions on the [OpenConext mailing list](https://openconext.org/get-involved/mailing-lists/) 
* Or you can join our [Slack Workspace](https://edu.nl/ocslk)
