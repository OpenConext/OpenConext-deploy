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
if [ $# -lt 5 ]
  then
    echo "INFO: Not enough arguments supplied, syntax: $BASENAME secret_vars_template  ebcertfiles_base shibspcertfiles_base oidcspcertfiles_base secret_vars_output"
    exit 1
fi

# ----- End Input handing

SECRET_VARS_TEMPLATE=$1
EBCERT_FILES_BASE=$2
SHIBCERT_FILES_BASE="$3"
OIDCCERT_FILES_BASE="$4"
SECRET_VARS_FILE=$5
OC_BASEDOMAIN=$6

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
    cat "${EBCERT_FILES_BASE}.key" | sed "s/^/    /g" >> "$SECRET_VARS_TEMP"
    continue
  fi

  if [ "$value" == 'shibboleth_sp_key' ]; then
    line="$key: |"
    echo "$line" >> $SECRET_VARS_TEMP
    cat "${SHIBCERT_FILES_BASE}.key" | sed "s/^/  /g" >> "$SECRET_VARS_TEMP"
    continue
  fi

  if [ "$value" == 'oidcng_private_key' ]; then
    line="$key: |"
    echo "$line" >> $SECRET_VARS_TEMP
    cat "${OIDCCERT_FILES_BASE}.key" | sed "s/^/  /g" >> "$SECRET_VARS_TEMP"
    continue
  fi
  if [ "$value" == 'oidcng_secret_keyset' ]; then
    line="$key: |"
    echo "$line" >> $SECRET_VARS_TEMP
    cat "${OIDCCERT_FILES_BASE}.keyset" | sed "s/^/  /g" >> "$SECRET_VARS_TEMP"
    continue
  fi
   

  echo "$line" >> $SECRET_VARS_TEMP
done < $SECRET_VARS_TEMPLATE


# Move temp file to SECRET_VARS_FILE
mv -f $SECRET_VARS_TEMP $SECRET_VARS_FILE

# Delete the keys that are now part of the secrets YAML file
rm "${EBCERT_FILES_BASE}.key"
rm "${SHIBCERT_FILES_BASE}.key"
rm "${OIDCCERT_FILES_BASE}.key"
# Delete the csrs as well
rm "${EBCERT_FILES_BASE}.csr"
rm "${SHIBCERT_FILES_BASE}.csr"
rm "${OIDCCERT_FILES_BASE}.csr"
