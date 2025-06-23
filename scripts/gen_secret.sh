#!/usr/bin/env bash

# Script to generate a random password, secret or hex key of the specified length and optionally encrypt it

SET="a-zA-Z0-9-_"

if [ $# -lt 1 ]; then
  echo "Usage $0 [--hex] [--encrypt <vault>] <length>"
  echo "Generate a secret of the specified length using characters from the set [${SET}]"
  echo "-hex, -h"
  echo "    Use hex digits [a-f0-9] instead of the default character set"
  echo "-encrypt <vault>, -e <vault>"
  echo "    Encrypt the secret with the specified vault"
  exit 1
fi

while [[ $# -gt 0 ]]; do
  option="$1"

  case $option in
  -h | --hex)
    SET="0-9a-f"
    shift
    ;;
  -e | --encrypt)
    shift
    VAULT="$1"
    shift
    if [ -z "${VAULT}" ]; then
      echo "--encrypt requires an argument"
      exit 1
    fi
    ;;
  -*)
    echo "Unknown option: '${option}'"
    exit 1;
    ;;
  *)
    break
  esac
done

LENGTH=$1

if [ -z "$LENGTH" ]; then
  echo "Length parameter is required"
  exit 1
fi
if [ "$LENGTH" -eq "0" ]; then
  secret=''
elif [ "$LENGTH" -gt "0" ]; then
  # Use C locale: env LC_CTYPE=C LC_ALL=C
  # Remove any characters not in the specified set: tr -dc "${SET}"
  # Use /dev/urandom as a source for randomness
  # Emit specifier number of characters head -c "$1"

  secret=$(env LC_CTYPE=C LC_ALL=C tr -dc "${SET}" < /dev/urandom | head -c "${LENGTH}")
  if [ ${#secret} -ne "${LENGTH}" ]; then
    echo "Error: Generated secret length (${#secret}) does not match requested length (${LENGTH})"
    exit 1
  fi

else
  echo "password length must be >= 0"
  exit 1
fi

if [ -n "${VAULT}" ]; then
  encrypt_cmd="$(dirname "$0")/encrypt"
  if [ -x "${encrypt_cmd}" ]; then
    # Use the encrypt command in the same dir as this script:
    #     encrypt ${VAULT} ${secret}
    "${encrypt_cmd}" "${VAULT}" "${secret}"
    res=$?
    if [ $res -ne 0 ]; then
      echo "Error: encrypt command failed with status ${res}"
      exit 1
    fi
  else
    echo "Error: encrypt command not found or not executable at ${encrypt_cmd}"
    exit 1
  fi
else
  echo $secret
fi

