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

# Requires a CA created with create_ca.sh
# Usage: <CA Directory> <basename> <Certificate DN> [keyvault for encrypting private key]

# Generate a SSL Server certificate and private key in the current directory
# Base name. Base name for certificate and private key
# DN: Certificate DN in OpenSSL format. e.g. "/CN=Common Name"

# If a keyczar keyvault directory is provided, the key that is output is encrypted.


CWD=`pwd`
BASEDIR=`dirname $0`
RSA_MODULUS_SIZE_BITS=2048
CERT_VALIDITY_DAYS=1095

function error_exit {
    echo "${1}"
    if [ -d ${tmpdir} ]; then
        rm -r ${tmpdir}
    fi
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
CERT_BASENAME=${2}
CERT_DN=${3}
KEY_DIR=${4}

if [ $# -lt 3 ]; then
    echo "Usage: $0 <CA directory> <basename> <Certificate DN> [keyvault for encrypting private key]"
    echo
    echo "CA directory: Directory previously created with create_ca.sh"
    echo "Basename: name for storing certificate and key. Files are written to the current directory"
    echo "Certificate DN: Enter the distinguised name (DN) in OpenSSL DN format. E.g. /CN=<common name>/O=<organisation>/C=<country-code>"
    echo "keyvault: If a keyczar keyvault directory is provided, the key that is output is encrypted."
    exit 1;
fi

if [ -e ${CERT_BASENAME}.key -o -e ${CERT_BASENAME}.pem ]; then
    echo "'${CERT_BASENAME}.key' or '${CERT_BASENAME}.pem' already exists. Leaving"
    exit 1;
fi

if [ ! -d ${CA_DIR} ]; then
    echo "CA Directory does not exist. Leaving"
    exit 1
fi
CA_DIR=`realpath ${CA_DIR}`

OPENSSL_CONF=${BASEDIR}/opensslca.conf

tmpdir=`mktemp -d -t sscrt.XXXXX`
if [ $? -ne "0" ]; then
    error_exit "Error creating TMP dir"
fi

${OPENSSL} req -newkey rsa:${RSA_MODULUS_SIZE_BITS} -keyout ${tmpdir}/private_key.pem -nodes -out ${tmpdir}/request.pem -config ${OPENSSL_CONF} -subj "${CERT_DN}"
if [ $? -ne "0" ]; then
    error_exit "Error generating certificate key"
fi


#-CA ${CA_DIR}/ca-cert.pem -CAkey ${CA_DIR}/ca-key.pem -CAcreateserial 


cd ${CA_DIR}
${OPENSSL} ca -config ${OPENSSL_CONF} -days ${CERT_VALIDITY_DAYS} -extensions v3_sslserver -in ${tmpdir}/request.pem -batch -out ${tmpdir}/certificate.pem
if [ $? -ne "0" ]; then
    error_exit "Error generating certificate"
fi
cd ${CWD}


if [ -d "${KEY_DIR}" ]; then
    crypted_private_key=`${BASEDIR}/encrypt-file.sh "${KEY_DIR}" -f "${tmpdir}/private_key.pem"`
    if [ $? -ne "0" ]; then
        error_exit "Error crypting private key"
    fi
    echo "${crypted_private_key}" > ${CERT_BASENAME}.key
else
    cp ${tmpdir}/private_key.pem ${CERT_BASENAME}.key
    if [ $? -ne "0" ]; then
        error_exit "Error copying private key"
    fi
fi

${OPENSSL} x509 -in ${tmpdir}/certificate.pem -out ${CERT_BASENAME}.pem
if [ $? -ne "0" -o ! -e ${CERT_BASENAME}.pem ]; then
    error_exit "Error copying certificate"
fi
