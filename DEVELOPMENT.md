Development Environment
==============================

The development environment differs to the other environments in three important ways, each will be highlighted below.

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

## Database Access

In the development environment an additional database user is created that has full access to all databases that are
present in the VM. The credentials are username: `development` and password `development`. This user can connect from
outside the VM, allowing you to set up your favorite Database Administration Tool for usage with this VM.

# How to set up the development environment

## Create the required Directory Structure

Due to the mounting requirements a specific directory structure is required. Easiest is to create a directory
`OpenConext` somewhere (e.g. `/opt/OpenConext`) and use that as root for all OpenConext projects. In this directory you
can checkout the OpenConext-deploy project without specifying a directory
(`git clone git@github.com:OpenConext/OpenConext-deploy.git`) Then repeat this for the OpenConect-engineblock project
(`git clone git@github.com:OpenConext/OpenConext-engineblock.git`). This creates the following directory structure:

```
/opt/OpenConext
      ├── OpenConext-deploy
      │   └── (project contents)
      └── OpenConect-engineblock
          └── (project contents)
```

In order to be able to run OpenConext EngineBlock, all dependencies must be installed by using [Composer][3] (
installation instructions can be found [here][4]). This is done by navigating to the OpenConext-engineblock project
and running `composer install`.

## Using Vagrant

The development environment can be created using [Vagrant][5]. In order to be use the additional functionality
such as provisioning specifically for development, all vagrant commands must be prefixed with `ENV=dev`.
In order to start using the development environment, navigate to the OpenConext-deploy project and run 
`ENV=dev vagrant up` to start the VMs and start the provisioning.

[1]: https://chrome.google.com/webstore/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc
[2]: https://addons.mozilla.org/en-us/firefox/addon/the-easiest-xdebug/
[3]: https://getcomposer.org/
[4]: https://getcomposer.org/download/
[5]: https://www.vagrantup.com/
