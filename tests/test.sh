#!/bin/bash

set -e

ansible-playbook -i inventory/docker --extra-vars="secrets_file=secrets/vm.yml" provision-vm.yml
