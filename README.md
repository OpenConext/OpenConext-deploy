Ansible-driven provisioning of the OpenConext platform.
==============================

# Getting started

These steps for setting up are based on Mac OS X and the Open Source [Homebrew](http://brew.sh) package manager. 
While it is possible to deploy OpenConext using other environments, currently it is unsupported.

To encrypt and decrypt values use the scripts in `./scripts/encrypt.sh` and `./scripts/encrypt-file.sh`. Run them without arguments to see the help.

## Install Vagrant and VirtualBox

VirtualBox is a powerful x86 and AMD64/Intel64 virtualization product, downloads and user manual can be found on the [VirtualBox website](https://www.virtualbox.org/wiki/Downloads).
> Vagrant provides easy to configure, reproducible, and portable work environments built on top of industry-standard technology and controlled by a single consistent workflow to help maximize the productivity and flexibility of you and your team.

For installation instructions see [the website](https://docs.vagrantup.com/v2/installation/index.html).

You will need at least Vagrant 1.7

To install both with Homebrew:

    brew tap caskroom/cask
    brew install brew-cask
    brew cask install vagrant
    brew cask install virtualbox

## Install GPG
Install GPG for your platform. For Mac, this is [GPG Tools] (https://gpgtools.org/).

Using your toolset, import the [gpg/vm.key](gpg/vm.key) and [gpg/vm.pub](gpg/vm.pub) into your GPG Keychain.

## Install Ansible

Ansible is the configuration tool we use to describe our servers.
Installation instruction can be found on the [Ansible website](http://docs.ansible.com/intro_installation.html).
The minimum required version of Ansible is 1.8.
To install for development with Homebrew:

    brew install python
    pip install --upgrade setuptools
    pip install --upgrade pip
    brew linkapps
    brew install ansible
    pip install python-keyczar==0.71c

## Run playbooks

For the VM environment the certificates are generated on the fly.
The VM will install everything on a single box for demo purposes.

To provision the VM please run:

```bash
./provision-vm
```

Which will:

1. Setup a Vagrant VM and will make sure the HOSTS file is able to handle the defined base_domain
2. Setup a MySQL server and LDAP for storage. In real environments it is advisable to install these on a separate box.
3. Inserts entitities and metadata in Janus and initial load of engineblock to bootstrap. **Rerunning this script will delete everything in Janus and Engineblock.**
4. Install all Java apps for the openconext platform.
5. Install all PHP apps for the openconext platform.
6. Install [mujina](https://github.com/OpenConext/Mujina) as IDP and SP for the VM environment.

## Add hostname entries to your own /etc/hosts file

We need pseudo-DNS entries so that your browser can reach the VM-platform we just installed. So, add this very long line to your `/etc/hosts` file:

```
192.168.66.78 api.vm.openconext.org static.vm.openconext.org db.vm.openconext.org serviceregistry.vm.openconext.org ldap.vm.openconext.org engine.vm.openconext.org  profile.vm.openconext.org apis.vm.openconext.org mujina-sp.vm.openconext.org mujina-idp.vm.openconext.org teams.vm.openconext.org manage.vm.openconext.org grouper.vm.openconext.org vm.openconext.org authz.vm.openconext.org voot.vm.openconext.org authz-admin.vm.openconext.org authz-playground.vm.openconext.org
```

Here, the ip-address `192.168.66.78` refers to the address that is mentioned in ./Vagrantfile.

## Enjoy your new VM!

Go to [https://vm.openconext.org](https://vm.openconext.org).

# Adding a new environment
Let's create an environment called 'foo'.

Prerequisites:

 * You have GPG installed.
 * You have a GPG identity.

## 1. Create symmetric encryption key for your env
Generate a keyczart keystore with primary AES key. Example:

```bash
 mkdir -p foo
 keyczart create --location=./foo --purpose=crypt
 keyczart addkey --location=./foo --status=primary
```

## 2. Tar the files inside the keystore-dir
The files are typically named '1' and 'meta',

```bash
tar c ./foo/* > foo.tar
```

## 3. GPG-crypt the tarred keystore.

Include yourself as a recipient or you won't be able to decrypt.

```bash
gpg --recipient 9561C684 --encrypt-files foo.tar
```

You can supply `--recipient` multiple times. If you're

## 4. Move the crypted file into place
Put the crypted file in gpg/tarred_and_crypted_keystores. Its name is important, so in this case it should be foo.tar.gpg.

## 5. Create the corresponding file in the Ansible inventory
Easiest way is probably to copy an existing file and modify it: `cp inventory/test inventory/foo'

Finally, commit and push your changes to the git repos.

# Note on custom vaults

This playbook uses a custom vault, defined in filter_plugins/custom_plugins.py in order to encrypt data. We think this is a better solution than the ansible-vault because it allows us to do fine grained encryption instead of a big ansible-vault file.
Also, the creator of ansible-vault admits his solution is not the way to go. See [this blogpost](http://jpmens.net/2014/02/22/my-thoughts-on-ansible-s-vault/).

# License

These files are licensed under version 2.0 of the Apache License, as described in the file [LICENSE](LICENSE).
