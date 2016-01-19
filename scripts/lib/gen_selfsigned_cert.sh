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

# Generate a self signed certificate and private key in the current directory
# Base name. Base name for certificate and private key
# DN: Certificate DN in OpenSSL format. e.g. "/CN=Common Name"

# If a keyczar directory is provided, the key that is output is encrypted.

CERT_VALID_DAYS=1825
RSA_MODULUS_SIZE_BITS=2048
CWD=`pwd`
BASEDIR=`dirname $0`

function error_exit {
    echo "${1}"
    if [ -d ${tmpdir} ]; then
        rm -r ${tmpdir}
    fi
    cd ${CWD}
    exit 1
}

if [ $# -lt 2 ]; then
    echo "Usage $0 <basename> <DN> [keyvault for encrypting private key]"
    exit 1
fi

CERT_BASENAME=${1}
CERT_DN=${2}
KEY_DIR=${3}

if [ -e ${CERT_BASENAME}.key -o -e ${CERT_BASENAME}.crt ]; then
    echo "'${CERT_BASENAME}.key' or '${CERT_BASENAME}.crt' already exist. Leaving"
    exit 1;
fi

OPENSSL=`which openssl`
if [ -z "${OPENSSL}" -o ! -x ${OPENSSL} ]; then
    echo "openssl is not in path or not executable. Please install openssl"
    exit 1;
fi
echo "Using openssl: ${OPENSSL}"

OPENSSL_CONF=${BASEDIR}/opensslca.conf

tmpdir=`mktemp -d -t sscrt.XXXXX`
if [ $? -ne "0" ]; then
    error_exit "Error creating TMP dir"
fi

# Generate RSA private key with RSA_MODULUS_SIZE_BITS bit modulus
${OPENSSL} genrsa -out ${tmpdir}/private_key.pem ${RSA_MODULUS_SIZE_BITS} -nodes
if [ $? -ne "0" ]; then
    error_exit "Error generating key"
fi

# Create certificate signing request
${OPENSSL} req -new -key ${tmpdir}/private_key.pem -out ${tmpdir}/csr.pem -subj "${CERT_DN}" -config ${OPENSSL_CONF}
if [ $? -ne "0" ]; then
    error_exit "Error creating certificate request"
fi

# Create self signed certificate
${OPENSSL} x509 -req -days ${CERT_VALID_DAYS} -in ${tmpdir}/csr.pem -signkey ${tmpdir}/private_key.pem -out ${tmpdir}/certificate.pem
if [ $? -ne "0" ]; then
    error_exit "Error creating certificate"
fi

if [ -d "${KEY_DIR}" ]; then
    crypted_private_key=`${BASEDIR}/encrypt-file.sh "${KEY_DIR}" -f "${tmpdir}/private_key.pem"`
    if [ $? -ne "0" ]; then
        error_exit "Error crypting private key"
    fi
    echo "${crypted_private_key}" > ${CERT_BASENAME}.key
else
    cp ${tmpdir}/private_key.pem ${CERT_BASENAME}.key
fi

cp ${tmpdir}/certificate.pem ${CERT_BASENAME}.crt

rm -r ${tmpdir}

exit 0

