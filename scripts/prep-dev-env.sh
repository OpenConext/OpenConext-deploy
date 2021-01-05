#!/usr/bin/env bash

echo "Restarting php-fpm, httpd"
sudo service php72-php-fpm restart
sudo service httpd restart

echo "Preparing dev env"
(cd /opt/openconext/OpenConext-engineblock && php72 $(which composer) prepare-env)
