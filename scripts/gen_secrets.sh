#!/bin/bash
#
# This script will generate new password, secrets and certificates for OpenConext.
# 
# It is to be used before any Ansible command.
#
# When a password must be sha-encoded, the clear-text password must be set before the sha-encoded
# Key for the sha-encoded password must be the same as the clear-text password with the '_sha'
#

# ----- Input handling
if [ $# -lt 4 ]
  then
    echo "INFO: Not enough arguments supplied, syntax: $BASENAME secret_vars_template certfiles_base ebcertfiles_base secret_vars_output"
    exit 1
fi


if [ $# -gt 4 ]
  then
    echo "ERROR: Only 4 arguments expected, syntax: $BASENAME secret_vars_template certfiles_base ebcertfiles_base secret_vars_output"
    exit 1
fi
# ----- End Input handing

SECRET_VARS_TEMPLATE=$1
CERT_FILES_BASE=$2
EBCERT_FILES_BASE=$3
SECRET_VARS_FILE=$4
OC_BASEDOMAIN=$5

tempfile() {
    tempprefix=$(basename "$0")
    mktemp /tmp/${tempprefix}.XXXXXX
}

SECRET_VARS_TEMP=$(tempfile)

while IFS= read -r line; do
  if [ -z "$line" ]; then
    echo "" >> $SECRET_VARS_TEMP
    continue
  fi
  if [ "$line" != "${line#\#}" ]; then
    echo "$line" >> $SECRET_VARS_TEMP
    continue
  fi

  key=$(printf "%s" "$line" | cut -f1 -d:)  
  value=$(echo $line | cut -f2 -d: | xargs)

  if [ "$value" == 'sha' ]; then
    # sha-key must be later in template file
    # lookup password for the non-sha variant (engine_ldap_password for engine_ldap_password_sha)
    # run command echo -n secret | sha1sum
    # where secret is the password
    passwordkey=`echo $key | sed 's/_sha$//g'`
    passwordline=`cat $SECRET_VARS_TEMP | grep -w $passwordkey`
    password=$(echo $passwordline | cut -f2 -d:)
    salt=`tr -c -d '0123456789abcdefghijklmnopqrstuvwxyz' </dev/urandom | dd bs=4 count=1 2>/dev/null;echo`
    ssha=`( echo -n ${password}${salt} | openssl dgst -sha1 -binary; echo -n ${salt} )  | openssl enc -base64`
    line="$key: \"{SSHA}$ssha\""
    echo "$line" >> $SECRET_VARS_TEMP
    continue
  fi

  if [ "$value" == 'salt' ]; then
    salt=`tr -c -d '0123456789abcdefghijklmnopqrstuvwxyz' </dev/urandom | dd bs=32 count=1 2>/dev/null;echo`
    line="$key: $salt "
    echo "$line" >> $SECRET_VARS_TEMP
    continue
  fi


  if [ "$value" == 'secret' ]; then
    password=`(tr -cd '[:alnum:]' < /dev/urandom | fold -w20 | head -n1)`
    line="$key: $password "
    echo "$line" >> $SECRET_VARS_TEMP
    continue
  fi

  if [ "$value" == 'engineblock_private_key' ]; then
    line="$key: |"
    echo "$line" >> $SECRET_VARS_TEMP
    cat "${EBCERT_FILES_BASE}.key" | sed "s/^/  /g" >> "$SECRET_VARS_TEMP"
    continue
  fi

  if [ "$value" == 'https_star_private_key' ]; then
    line="$key: |"
    echo "$line" >> $SECRET_VARS_TEMP
    cat "${CERT_FILES_BASE}.key" | sed "s/^/  /g" >> "$SECRET_VARS_TEMP"
    continue
  fi

  echo "$line" >> $SECRET_VARS_TEMP
done < $SECRET_VARS_TEMPLATE


# Move temp file to SECRET_VARS_FILE
mv -f $SECRET_VARS_TEMP $SECRET_VARS_FILE
