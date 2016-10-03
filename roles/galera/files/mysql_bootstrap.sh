#!/usr/bin/env bash

# Bootstrap a mysql installation on CentOS / Redhat
# This is the non interactive and idempotent equivalent of the "mysql_secure_installation" installation script
# - Set a password on the root accounts
# - remove test database
# - remove anonymous users
#
# Usage: mysql_bootstrap.sh "<mysql root password>"
#
# Return code:
# 0: success, no changes
# 1: success, changes
# 2: error

mysql_root_password=$1
changes=0

if [ -z ${mysql_root_password} ]; then
   echo "Usage $0 <mysql root password>"
   exit 2
fi

#Test login as user root to localhost without password
#Note there are more root accounts beside @localhost: @127.0.0.1, @::1 and @<hostname>
#We don't test for these below, only localhost.
out_err=$( mysql --user=root --host=localhost --password= -e exit 2>&1 )
# May return (MariaDB 10 om CentOS 7):
# Service down: ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/lib/mysql/mysql.sock' (2 "No such file or directory")
# Wrong password: ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)
res=$?

if [ $res == 0 ]; then
   echo "Root access without password is allowed to localhost. Setting new root password for all root users."
   changed=1
   mysql --user=root --password= -e "UPDATE mysql.user SET Password = PASSWORD('${mysql_root_password}') WHERE User = 'root'; FLUSH PRIVILEGES;"
   res=$?
   if [ $res == 1 ]; then
      echo "Error setting new mysql password"
      exit 2;
   fi
   echo "Set new password for mysql user root"
elif [[ ${out_err} ==  "ERROR 1045 (28000)"* ]]; then
   # Access denied for user root. There is a password set
   echo "Mysql root account has a password set"
else
   echo "Unexpected error from mysql:"
   echo ${out_err}
   exit 2
fi

# Fix any root acounts that we may have missed
echo -n "Securing all root accounts... "
out=`mysql -u root -p${mysql_root_password} -N -B -e "UPDATE mysql.user SET Password = PASSWORD('${mysql_root_password}') WHERE User = 'root'; SELECT ROW_COUNT(); FLUSH PRIVILEGES;"`
res=$?
if [ ${res} == 0 ]; then
   if [ "${out}" -gt "0" ]; then
      changed=1
      echo "Changed. OK"
   else
      echo "OK"
   fi
else
   echo "Failed"
   exit 2
fi


echo -n "Removing anonymous users (if any)... "
out=`mysql -u root -p"${mysql_root_password}" -N -B -e "DELETE FROM mysql.user WHERE User = ''; SELECT ROW_COUNT(); FLUSH PRIVILEGES;"`
res=$?
if [ ${res} == 0 ]; then
   if [ "${out}" -gt "0" ]; then
      changed=1
      echo "Changed. OK"
   else
      echo "OK"
   fi
else
   echo "Failed"
   exit 2
fi


echo -n "Removing test schema/database (if any)... "
out=`mysql -u root -p"${mysql_root_password}" -N -B -e "DROP DATABASE IF EXISTS test; SELECT ROW_COUNT();"`
res=$?
if [ ${res} == 0 ]; then
   if [ "${out}" -gt "0" ]; then
      changed=1
      echo "Changed. OK"
   else
      echo "OK"
   fi
else
   echo "Failed"
   exit 2
fi


exit ${changed}
