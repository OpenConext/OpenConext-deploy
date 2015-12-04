#! /bin/bash

#
# This script will generate new certificates for OpenConext.
#
# It is to be used before any Ansible command.
#

SECRET_VARS_FILE=../secrets/secret-vars.yml

# ----- End configuration

# ----- Input handling
if [ $# -eq 0 ]
  then
    echo "INFO: No arguments supplied, using default secrets file" $SECRET_VARS_FILE
fi

if [ $# -gt 1 ]
  then
    echo "ERROR: Only 1 argument expected please supply only the file containing the secrets, for example " $SECRET_VARS_FILE
    exit 1
fi
# ----- End Input handing

if [ $# -eq 1 ]
  then
    SECRET_VARS_FILE=$1
    echo "INFO: Using file " $SECRET_VARS_FILE " for containing the secrets."
fi

set -x

oc_env=`grep "^env: " $SECRET_VARS_FILE | cut -f2 -d: | xargs`
oc_basedomain=`grep "^base_domain: " $SECRET_VARS_FILE | cut -f2 -d: | xargs  | sed "s/{{ env }}/$oc_env/g"`

echo $oc_basedomain

# create some directories for housekeeping
mkdir -p ./oc_certs/ssl
mkdir -p ./oc_certs/signing
#mkdir -p ./oc_certs/api

#HTTPS certs voor Web omgeving
./create_ca.sh ./oc_certs/ca "/CN=OpenConext Demo CA/O=OpenConext/C=NL"
./gen_ssl_server_cert.sh  ./oc_certs/ca ./oc_certs/ssl/star.$oc_basedomain /CN=*.$oc_basedomain/O=OpenConext/C=NL

#SAML Signing CERT
./gen_selfsigned_cert.sh ./oc_certs/signing/OpenConextDemoSAMLSigning "/CN=OpenConext Demo Saml Signing Certificate/O=OpenConext/C=NL"

#API needs certs in a special form (pkcs8)
# openssl pkcs8 -topk8 -inform PEM -outform PKCS8 -in api.pem -out api_pkcs8.pem -nocrypt
#/usr/bin/openssl pkcs8 -topk8 -inform PEM -outform PKCS8 -in ./oc_certs/ssl/star.$oc_basedomain.crt -out ./oc_certs/api/star.$oc_basedomain.pem_pkcs8.pem -nocrypt


### Create directory for ansible to pick up certificates

mkdir -p ../files/$oc_env/certs
if [ ! -f ../files/$oc_env/certs/engineblock.crt ]; then
  cp ./oc_certs/signing/OpenConextDemoSAMLSigning.crt ../files/$oc_env/certs/engineblock.crt
else
  echo "Skipping engineblock.crt, already exist"
fi

if [ ! -f ../files/$oc_env/certs/star.$oc_basedomain.pem ]; then
  cp ./oc_certs/ssl/star.$oc_basedomain.crt ../files/$oc_env/certs/star.$oc_basedomain.pem
else
  echo "Skipping star.$oc_basedomain.pem, already exist"
fi

#### API and APIS cert are not used anymore, but copied for backward compatibility (ansible role vm_onlyprovision_eb_sr may still contain references to these files
if [ ! -f ../files/$oc_env/certs/api.crt ]; then
  cp ./oc_certs/signing/OpenConextDemoSAMLSigning.crt ../files/$oc_env/certs/api.crt
else
  echo "Skipping api.crt, already exist"
fi


if [ ! -f ../files/$oc_env/certs/apis.crt ]; then
  cp ./oc_certs/signing/OpenConextDemoSAMLSigning.crt ../files/$oc_env/certs/apis.crt
else
  echo "Skipping apis.crt, already exist"
fi

pushd ../files/
ln -s $oc_env java-$oc_env
ln -s $oc_env php-$oc_env
popd
