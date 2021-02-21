#!/bin/bash
#
# This script will generate a master key that is used to encrypt all the OIDC keys which are stored in the database
# It will download a java binary and use that to generate the key
# The key will be added to the secrets
# ----- Input handling
if [ $# -lt 1 ]
  then
    echo "INFO: No arguments supplied, syntax: $BASENAME secretsfile"
    exit 1
fi


if [ $# -gt 1 ]
  then
    echo "ERROR: Only 3 arguments expected, syntax: $BASENAME secretsfile"
    exit 1
fi

# ----- End Input handing
#
CURL_BIN=`which curl`
JAVA_BIN=`which java`
OIDC_KEYSET_FILE=$1

## First we download the binary to /tmp
$CURL_BIN  -o crypto-1.0.1-shaded.jar https://build.openconext.org/repository/public/releases/org/openconext/crypto/1.0.1/crypto-1.0.1-shaded.jar
## Execute it, and send the key to the secrets file
echo "create the keyset"
$JAVA_BIN -version
$JAVA_BIN -jar crypto-1.0.1-shaded.jar > $OIDC_KEYSET_FILE
## Clean up the binary
rm crypto-1.0.1-shaded.jar
echo "done creating the keyset"

