#! /bin/bash

# create some directories for housekeeping
mkdir -p ./oc_certs/ssl
mkdir -p ./oc_certs/signing
#mkdir -p ./oc_certs/api

#HTTPS certs voor Web omgeving
./create_ca.sh ./oc_certs/ca "/CN=OpenConext Demo CA/O=OpenConext/C=NL"
./gen_ssl_server_cert.sh  ./oc_certs/ca ./oc_certs/ssl/star.demo.openconext.org /CN=*.demo.openconext.org/O=OpenConext/C=NL

#SAML Signing CERT
./gen_selfsigned_cert.sh ./oc_certs/signing/OpenConextDemoSAMLSigning "/CN=OpenConext Demo Saml Signing Certificate/O=OpenConext/C=NL"

#API needs certs in a special form (pkcs8)
# openssl pkcs8 -topk8 -inform PEM -outform PKCS8 -in api.pem -out api_pkcs8.pem -nocrypt
#/usr/bin/openssl pkcs8 -topk8 -inform PEM -outform PKCS8 -in ./oc_certs/ssl/star.demo.openconext.org.crt -out ./oc_certs/api/star.demo.openconext.org.pem_pkcs8.pem -nocrypt
