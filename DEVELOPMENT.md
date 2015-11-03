Development Environment
==============================

# Introduction
The `./provision-develop` script is a utility, analogous to existing `provision-*` bash scripts,
for setting up and managing development VM's for EngineBlock.

## The provision-develop script
The script sets certain variables for Vagrant and Ansible, so you don't have to. Consequently,
_plain Vagrant commands like `vagrant up` will not properly bring the development VM's up_.
This is why additional commands are available by adding them as a parameter: `./provision-develop {command}`.

The following commands are available:
- `halt`: halts vagrant box.
- `help`: shows this help page.
- `logs {lb|apps}`: shows all non-encrypted, non-zipped logs of specified vm.
- `provision`: provisions vagrant box.
- `reload`: reloads vagrant box.
- `up`: runs vagrant up without provisioning.

If no command is given you are prompted whether or not you want to run vagrant up with provisioning.

## Mounting EngineBlock
Unlike other provisioning scripts, it will not download and symlink EngineBlock in a folder on the
VM as it will mount a (shared) directory, expected to be present at `../OpenConext-engineblock/` and
accessible on the `apps` VM at `/opt/openconext/OpenConext-engineblock`.

This way, one can easily manage OpenConext-engineblock code from outside the VM.

## Xdebug
For development purposes, provisioning the `apps` VM includes Xdebug. To circumvent the `loadbalancer` VM, it is
configured with `192.168.66.1` as IP of the host machine. Should there be any issues, make sure this IP address is
correct for your setup. The IDEkey used is `PHPSTORM`. It is not configured to automatically connect to the IDE, as this
gives issues with the requests made by haproxy as well as being unable to map all PHP applications to code in
EngineBlock. Simplest is to use a browser addon to enable xdebug for that request, such as [this Chrome addon][1] or
[this Firefox addon][2].

# How to set up the development environment

## Create the required Directory Structure

Due to the mounting requirements a specific directory structure is required. Easiest is to create a directory
`OpenConext` somewhere (e.g. `~/OpenConext`) and use that as root for all OpenConext projects. In this directory you
can checkout the OpenConext-deploy project without specifying a directory
(`git clone git@github.com:OpenConext/OpenConext-deploy.git`) Then repeat this for the OpenConect-engineblock project
(`git clone git@github.com:OpenConext/OpenConext-engineblock.git`). This creates the following directory structure:

```
OpenConext
  ├── OpenConext-deploy
  │   └── (project contents)
  └── OpenConect-engineblock
      └── (project contents)
```

In order to be able to run OpenConext EngineBlock, all dependencies must be installed by using [Composer][3] (
installation instructions can be found [here][4]). This is done by navigating to the OpenConext-engineblock project
and running `composer install`.

After this has been done you can navigate to the OpenConext-deploy project and run `./provision-develop` (confirm the
action when prompted) to start the VMs and start the provisioning.

[1]: https://chrome.google.com/webstore/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc
[2]: https://addons.mozilla.org/en-us/firefox/addon/the-easiest-xdebug/
[3]: https://getcomposer.org/
[4]: https://getcomposer.org/download/
