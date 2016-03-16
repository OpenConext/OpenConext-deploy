#!/usr/bin/env bash

echo "Restarting php-fpm, httpd and tomcat"
sudo service php-fpm restart
sudo service httpd restart
sudo service tomcat restart

echo "Preparing dev env"
(cd /opt/openconext/OpenConext-engineblock && composer prepare-env)
