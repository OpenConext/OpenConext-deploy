#!/bin/bash
#
# This script will generate new password, secrets and certificates for OpenConext.
# 
# It is to be used before any Ansible command.
#
# When a password must be sha-encoded, the clear-text password must be set before the sha-encoded
# Key for the sha-encoded password must be the same as the clear-text password with the '_sha'
#

SECRET_VARS_FILE=../secrets/secret-vars.yml
SECRET_VARS_TEMPLATE_FILE=../templates/secret-vars-template.yml
# ----- End configuration

SCRIPT=$(readlink -f "$0")
BASEDIR=$(dirname "$SCRIPT")
BASENAME=$(basename "$SCRIPT")

# ----- Input handling
if [ $# -lt 2 ]
  then
    echo "INFO: No arguments supplied, syntax: $BASENAME environment domain [secret-vars-file]"
    exit 1
fi

if [ $# -eq 2 ]
  then
    echo "INFO: No secret file supplied, using default secrets file" $SECRET_VARS_FILE
fi

if [ $# -gt 3 ]
  then
    echo "ERROR: Only 2 or 3 arguments expected, syntax: $BASENAME environment domain [secret-vars-file]"
    exit 1
fi
# ----- End Input handing

if [ $# -eq 3 ]
  then
    SECRET_VARS_FILE=$3
    echo "INFO: Using file " $SECRET_VARS_FILE " for containing the secrets."
fi

oc_env=$1
oc_basedomain=$2

set -e
#set -x

tempfile() {
    tempprefix=$(basename "$0")
    mktemp /tmp/${tempprefix}.XXXXXX
}


SV_FILE=$(tempfile)
trap 'rm -f $SV_FILE; echo "Error: Operation not completed, please restart command"' EXIT INT TERM 

BASEDIR=$(dirname $0)

while IFS= read -r line
do
  if [ -z "$line" ]; then
    echo "" >> $SV_FILE
    continue
  fi
  if [ "$line" != "${line#\#}" ]; then
    echo "$line" >> $SV_FILE
    continue
  fi

  key=$(printf "%s" "$line" | cut -f1 -d:)  
  value=$(echo $line | cut -f2 -d: | xargs)

  if [ "$key" == 'env' ]; then
    line="env: $oc_env"
    echo "$line" >> $SV_FILE
    continue
  fi

  if [ "$key" == 'base_domain' ]; then
    line="base_domain: \"{{ env }}.$oc_basedomain\""
    echo "$line" >> $SV_FILE
    continue
  fi

  if [ "$value" == 'sha' ]; then
    # sha-key must be later in template file
    # lookup password for the non-sha variant (engine_ldap_password for engine_ldap_password_sha)
    # run command echo -n secret | sha1sum
    # where secret is the password
    passwordkey=`echo $key | sed 's/_sha$//g'`
    passwordline=`cat $SV_FILE | grep -w $passwordkey`
    password=$(echo $passwordline | cut -f2 -d:)
    salt="$(openssl rand -base64 3)"
    ssha=$(echo -n ${password}${salt}| openssl dgst -binary -sha1 | sed 's#$#'"$salt"'#' | base64);
    line="$key: \"{SSHA}$ssha\""
    echo "$line" >> $SV_FILE
    continue
  fi

  if [ "$value" == 'salt' ]; then
    salt=`tr -c -d '0123456789abcdefghijklmnopqrstuvwxyz' </dev/urandom | dd bs=32 count=1 2>/dev/null;echo`
    line="$key: $salt "
    echo "$line" >> $SV_FILE
    continue
  fi


  if [ "$value" == 'secret' ]; then
    password=`(tr -cd '[:alnum:]' < /dev/urandom | fold -w20 | head -n1)`
    line="$key: $password "
    echo "$line" >> $SV_FILE
    continue
  fi

  if [ "$value" == 'engineblock_private_key' ]; then
    line="$key: |"
    echo "$line" >> $SV_FILE
    cat "$BASEDIR/oc_cert/signing/OpenConextDemoSAMLSigning.key" | sed "s/^/  /g" >> "$SV_FILE"
    continue
  fi

  if [ "$value" == 'https_star_private_key' ]; then
    line="$key: |"
    echo "$line" >> $SV_FILE
    cat "$BASEDIR/oc_cert/ssl/star.$oc_env.$oc_basedomain.key" | sed "s/^/  /g" >> "$SV_FILE"
    continue
  fi

  echo "$line" >> $SV_FILE

  
done < $SECRET_VARS_TEMPLATE_FILE

#read

mv -f $SV_FILE $SECRET_VARS_FILE
trap '' EXIT
exit 0

