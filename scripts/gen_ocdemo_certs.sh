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

#set -x

oc_env=`grep "^env: " $SECRET_VARS_FILE | cut -f2 -d: | xargs`
oc_basedomain=`grep "^base_domain: " $SECRET_VARS_FILE | cut -f2 -d: | xargs  | sed "s/{{ env }}/$oc_env/g"`

BASEDIR=$(dirname $0)

# create some directories for housekeeping
mkdir -p $BASEDIR/oc_certs/ssl
mkdir -p $BASEDIR/oc_cert/signing
#mkdir -p $BASEDIR/oc_cert/api

#HTTPS certs voor Web omgeving
./lib/create_ca.sh $BASEDIR/oc_cert/ca "/CN=OpenConext Demo CA/O=OpenConext/C=NL"
./lib/gen_ssl_server_cert.sh  $BASEDIR/oc_cert/ca $BASEDIR/oc_cert/ssl/star.$oc_basedomain /CN=*.$oc_basedomain/O=OpenConext/C=NL

#SAML Signing CERT
./lib/gen_selfsigned_cert.sh $BASEDIR/oc_cert/signing/OpenConextDemoSAMLSigning "/CN=OpenConext Demo Saml Signing Certificate/O=OpenConext/C=NL"

### Create directory for ansible to pick up certificates

mkdir -p ../files/$oc_env/certs
if [ ! -f ../files/$oc_env/certs/engineblock.crt ]; then
  cp $BASEDIR/oc_cert/signing/OpenConextDemoSAMLSigning.crt ../files/$oc_env/certs/engineblock.crt
else
  echo "Skipping engineblock.crt, already exist"
fi

if [ ! -f ../files/$oc_env/certs/star.$oc_basedomain.pem ]; then
  cp $BASEDIR/oc_cert/ssl/star.$oc_basedomain.crt ../files/$oc_env/certs/star.$oc_basedomain.pem
else
  echo "Skipping star.$oc_basedomain.pem, already exist"
fi

#### API and APIS cert are not used anymore, but copied for backward compatibility (ansible role vm_onlyprovision_eb_sr may still contain references to these files
if [ ! -f ../files/$oc_env/certs/api.crt ]; then
  cp $BASEDIR/oc_cert/signing/OpenConextDemoSAMLSigning.crt ../files/$oc_env/certs/api.crt
else
  echo "Skipping api.crt, already exist"
fi


if [ ! -f ../files/$oc_env/certs/apis.crt ]; then
  cp $BASEDIR/oc_cert/signing/OpenConextDemoSAMLSigning.crt ../files/$oc_env/certs/apis.crt
else
  echo "Skipping apis.crt, already exist"
fi

pushd ../files/
if [ -f java-$oc_env ]; then
  ln -s $oc_env java-$oc_env
fi
if [ -f php-$oc_env ]; then
  ln -s $oc_env php-$oc_env
fi
popd
