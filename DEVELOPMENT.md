Development Environment
==============================

# Introduction
The `./provision-develop` script is a utility, analogous to existing `provision-*` bash scripts, for setting up and managing development VM's for EngineBlock.

## Mounting EngineBlock
Unlike other provisioning scripts, it will not download and symlink EngineBlock in a folder on the VM as it will mount a (shared) directory, expected to be present at `../OpenConext-engineblock/` and accessible on the `apps` VM at `/opt/openconext/OpenConext-engineblock`.
This way, one can easily checkout OpenConext-engineblock branches from outside the VM.

## Xdebug
For development purposes, provisioning the `apps` VM includes Xdebug. To circumvent the `loadbalancer` VM, it is configured with `192.168.66.1` as IP of the host machine. 
Should there be any issues, make sure this IP address is correct for your setup.
No cookie is required for it to work.

# Setup
When setting up a development environment, run `./provision-develop` to bring up the Vagrant boxes and to provision them through Ansible.

Be sure to checkout an OpenConext-engineblock branch in the `../OpenConext-engineblock/` directory relative to the `OpenConext-deploy` project directory.

Project dependencies can be installed using `composer install` in the `OpenConext-engineblock` directory on the VM or on the host machine.

# Special commands
The script sets certain variables for Vagrant and Ansible, so one does not have to do so manually. Consequently, plain Vagrant commands like `vagrant up` will not properly bring the development VM's up.
This is why special commands are available by adding them as a parameter as follows: `./provision-develop {command}`.

The following commands are available:
   - `halt`: halts vagrant box.
   - `help`: shows this help page.
   - `logs {lb|apps}`: shows all non-encrypted, non-zipped logs of specified vm.
   - `provision`: provisions vagrant box.
   - `reload`: reloads vagrant box.
   - `up`: runs vagrant up without provisioning.





