#!/bin/bash
#
# This script generates new self-signed certificate based on basedomain and env
# 
# It is part of prep-env script.
#


# ----- Input handling
if [ $# -lt 3 ]
  then
    echo "INFO: No arguments supplied, syntax: $BASENAME environment domain filebase"
    exit 1
fi


if [ $# -gt 4 ]
  then
    echo "ERROR: Only 3 arguments expected, syntax: $BASENAME environment domain filebase"
    exit 1
fi
# ----- End Input handing


tempfile() {
    tempprefix=$(basename "$0")
    mktemp /tmp/${tempprefix}.XXXXXX
}

CERT_CONF_TEMP=$(tempfile)

OC_ENV=$1
OC_BASEDOMAIN=$2
CERT_FILES_BASE=$3

# Generate new certificates
cat <<@eof >$CERT_CONF_TEMP
extensions = extend
[req] # openssl req params
prompt = no
distinguished_name = dn-param
[dn-param] # DN fields
C = NL
O = ${OC_BASEDOMAIN}
CN = ${OC_BASEDOMAIN}
emailAddress = "info@${OC_BASEDOMAIN}"
[extend] # openssl extensions
subjectAltName=DNS:${OC_BASEDOMAIN},DNS:*.${OC_BASEDOMAIN}
@eof

# Generate SelfSigned cert
echo "Generating private key"
openssl genrsa -out "${CERT_FILES_BASE}.key" 2048
echo "Generating csr"
openssl req -new -key "${CERT_FILES_BASE}.key" -config "${CERT_CONF_TEMP}" -out "${CERT_FILES_BASE}.csr"
echo "Generating 3 yr crt"
openssl x509 -req -sha256 -days 1095 -in "${CERT_FILES_BASE}.csr" -signkey "${CERT_FILES_BASE}.key" -text -extfile "${CERT_CONF_TEMP}" -out "${CERT_FILES_BASE}.crt"

# Remove CERT_CONF_TEMP
rm $CERT_CONF_TEMP
