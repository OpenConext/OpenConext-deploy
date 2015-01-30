Ansible-driven provisioning the OpenConext platform.
==============================

# Getting started

These step for setting up are based on Mac OS X and the Open Source [Homebrew](http://brew.sh) package manager. 
While it is possible to deploy OpenConext using other environments, currently it is unsupported.

To encrypt and decrypt values use the scripts in `./scripts/encrypt.sh` and `./scripts/encrypt-file.sh`. Run them without arguments to see the help.

## Install Vagrant and VirtualBox

VirtualBox is a powerful x86 and AMD64/Intel64 virtualization product, downloads and user manual can be found on the [VirtualBox website](https://www.virtualbox.org/wiki/Downloads).
> Vagrant provides easy to configure, reproducible, and portable work environments built on top of industry-standard technology and controlled by a single consistent workflow to help maximize the productivity and flexibility of you and your team.

For installation instructions see [the website](https://docs.vagrantup.com/v2/installation/index.html).

To install both with Homebrew:

    sudo brew tap caskroom/cask &&
    sudo brew install brew-cask &&
    sudo brew cask install vagrant &&
    sudo brew cask install virtualbox

## Install Ansible

Ansible is the configuration tool we use to describe our servers.
Installation instruction can be found on the [Ansible website](http://docs.ansible.com/intro_installation.html).
To install for development with Homebrew:

    sudo brew install python &&
    sudo pip install --upgrade setuptools &&
    sudo pip install --upgrade pip &&
    sudo brew linkapps &&
    sudo brew install ansible &&
    sudo pip install python-keyczar==0.71c


# Deploy to a (development) VM

The VM setup is intended for demo purposes only since it is using the `openconext-unsafe-keystore`.

Create the symlink so that our playbook can find the AES key in this project:

`ln -s $CURRENT_DIR/openconext-unsafe-keystore ~/.openconext-keystore`

The setup of the VM is using the `openconext-unsafe-keystore`, don't use that in production.


## Run playbooks

For the VM environment the certificates are generated on the fly. Typically you would only run `openconext-java.yml` for installing the java apps on a target environment.
The VM will install everything on a single box for demo purposes.

To provision the VM please run:

```bash

vagrant up &&
./ansible-vm openconext-storage.yml &&
./ansible-vm openconext-java.yml &&
./ansible-vm openconext-php.yml &&
./ansible-vm openconext-mujina.yml
```

Which will:
1. Setup a VM and will make sure the HOSTS file is able to handle the defined base_domain
2. Setup a MySQL server and LDAP for storage. In real environments it is advisable to install these on a separate box.
3. Install all Java apps for the openconext platform.
4. Install all PHP apps for the openconext platform.
5. Install [mujina](https://github.com/OpenConext/Mujina) as IDP and SP for the VM environment.

## Enjoy your new VM!

Go to [https://vm.openconext.org](https://vm.openconext.org).

# Deploy to test / staging / production

## Create your own keystore(s)

Create a keystore on an encrypted disk partition, to keep it extra safe (e.g. in case of laptop-loss).
Here's how to [create an encrypted folder](http://apple.stackexchange.com/questions/129720/how-can-i-encrypt-a-folder-in-os-x-mavericks) on your Mac.

This is how the keystore is created (you don't have to do this if it already exists for your project).
See [this blogpost](http://www.saltycrane.com/blog/2011/10/notes-using-keyczar-and-python/) for example.

`keyczart create --location=PATH_TO_FOLDER --purpose=crypt`

`keyczart addkey --location=PATH_TO_FOLDER --status=primary`

Create the symlink so that our playbook can find the AES key in this project:

`ln -s PATH_TO_FOLDER ~/.openconext-keystore`

Once created the keystore needs to be shared with your colleagues who also need to deploy. Whether you choose to check in into a git repo is all up to you.
As long as a ~/.openconext-keystore exists the provision scripts will work.

**Notice: When the crypted store is compromised you should change all encrypted values ASAP. The same goes for when you loose your home key, you should change the locks.**

## Create group_vars and inventory for you environment.

Currently in `./inventory` only the `vm` inventory file exists. This describes the vm environment. When for instance creating a production setup create an inventory file called `production`.
To deploy the openconext-java apps to this new production environment you should:

1. copy the openconext-java setup and adjust accordingly

        [openconext-java]
        PRODUCTION_ADDRESS_HERE

        [openconext-java-production:children]
        openconext-java

2. Create a `groups_vars/openconext-java-production.yml` and adjust values accordingly. There is a special property (`env`) that is also used to determine where to look for certificates and such.
    In this case use `production` as `env`.

3. Place your certificates in `java-production/certs` and `php-production/certs`. If you are going to checkin the private keys as well please make sure you encrypt them using `scripts/encrypt-file.sh`.

4. Run ansible-playbook -u USERNAME -i inventory/production openconext-java.yml (USERNAME needs sudo rights, use -K when a password is needed to sudo)

# Notes on custom vaults

This playbook uses a custom vault, defined in filter_plugins/custom_plugins.py in order to encrypt data. We think this is a better solution than the ansible-vault because it allows us to do fine grained encryption instead of a big ansible-vault file.
Also, the creator of ansible-vault admits his solution is not the way to go. See [this blogpost](http://jpmens.net/2014/02/22/my-thoughts-on-ansible-s-vault/).
