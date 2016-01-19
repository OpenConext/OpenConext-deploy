#!/bin/bash

# Copyright 2015 SURFnet B.V.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

CWD=`pwd`
BASEDIR=`dirname $0`
CA_VALIDITY_DAYS=3650
CA_RSA_MODULUS_SIZE_BITS=4096

function error_exit {
    echo "${1}"
    rm -r ${CA_DIR}
    cd ${CWD}
    exit 1
}

function realpath {
    if [ ! -d ${1} ]; then
        return 1
    fi
    current_dir=`pwd`
    cd ${1}
    res=$?
    if [ $? -eq "0" ]; then
        path=`pwd`
        cd $current_dir
        echo $path
    fi
    return $res
}

BASEDIR=`realpath ${BASEDIR}`

OPENSSL=`which openssl`
if [ -z "${OPENSSL}" -o ! -x ${OPENSSL} ]; then
    echo "openssl is not in path or not executable. Please install openssl"
    exit 1;
fi
echo "Using openssl: ${OPENSSL}"

# Process options
CA_DIR=${1}
CA_DN=${2}
if [ $# -lt 2 ]; then
    echo "Usage: $0 <CA directory> <CA DN>"
    echo
    echo "The CA directory must not exist yet."
    echo "Enter the distinguised name (DN) in OpenSSL DN format. E.g. /CN=<common name>/O=<organisation>/C=<country-code>"
    exit 1;
fi


if [ -e ${CA_DIR} ]; then
    echo "CA Directory already exists. Leaving"
    exit 1
fi

mkdir -p ${CA_DIR}

CA_DIR=`realpath ${CA_DIR}`
if [ $? -ne "0" ]; then
    error_exit "Could not change to CA dir"
fi

echo "Initializing a new CA in: ${CA_DIR}"

OPENSSL_CONF=${BASEDIR}/opensslca.conf

cd ${CA_DIR}
mkdir -p certs

echo "01" > serial
touch index.txt

${OPENSSL} req -x509 -newkey rsa:${CA_RSA_MODULUS_SIZE_BITS} -out ${CA_DIR}/ca-cert.pem -outform PEM -nodes -config ${OPENSSL_CONF} -keyout ${CA_DIR}/ca-key.pem -sha256 -extensions v3_ca -set_serial 0 -days ${CA_VALIDITY_DAYS} -subj "${CA_DN}"
if [ $? -ne "0" ]; then
    error_exit "Error generating CA root certificate and key"
fi

echo "Wrote CA certificate to: ${CA_DIR}/ca-cert.pem"

echo "Generated CA certificate:"
${OPENSSL} x509 -in ${CA_DIR}/ca-cert.pem -text

cd ${CWD}
