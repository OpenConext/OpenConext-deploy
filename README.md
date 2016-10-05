Ansible-driven provisioning of the OpenConext platform.
==============================

[![Build Status](https://travis-ci.org/OpenConext/OpenConext-deploy.svg?branch=master)](https://travis-ci.org/OpenConext/OpenConext-deploy)

# Getting started

# Deploy to a remote machine

A manual to run the deploy to a single target machine (e.g. a hosted VM) is in the wiki:
[Installation steps to deploy OpenConext on a single system](https://github.com/OpenConext/OpenConext-deploy/wiki/Installation-steps-to-deploy-OpenConext-on-a-single-system-other-than-the-Vagrant-VM-centOS7).

# Deploy with Vagrant

To run a development instance on your local machine with Vagrant and VirtualBox, follow these steps.
They are based on Mac OS X and the Open Source [Homebrew](http://brew.sh) package manager. 

## Install Vagrant and VirtualBox

VirtualBox is a powerful x86 and AMD64/Intel64 virtualization product, downloads and user manual can be found on the [VirtualBox website](https://www.virtualbox.org/wiki/Downloads).
> Vagrant provides easy to configure, reproducible, and portable work environments built on top of industry-standard technology and controlled by a single consistent workflow to help maximize the productivity and flexibility of you and your team.

For installation instructions see [the website](https://docs.vagrantup.com/v2/installation/index.html).

You will need at least Vagrant 1.7. Do not use Vagrant 1.8.5, which contains a bug that makes that the provisioning fails with the message "Warning: Authentication failure. Retrying...". 

To install both with Homebrew:

    brew tap caskroom/cask
    brew install brew-cask
    brew cask install vagrant
    brew cask install virtualbox

With the above commands you get the latest versions. There might be incompatibilities. Vagrant will tell you and if you need a different version install cask versions and install the correct version of virtualbox and / or vagrant:

    brew tap caskroom/versions
    brew cask install virtualbox4330101610

## Install Ansible

Ansible is the configuration tool we use to describe our servers.
Installation instruction can be found on the [Ansible website](http://docs.ansible.com/intro_installation.html).
The minimum required version of Ansible is 1.9.
To install for development with Homebrew:

    brew install python
    pip install --upgrade setuptools
    pip install --upgrade pip
    brew linkapps
    brew install ansible

## Run playbooks

The VM will install everything on a two boxes for demo purposes.

To provision the VM please run:

```bash
Download the latest release:
wget https://github.com/OpenConext/OpenConext-deploy/archive/v2.0.tar.gz 
Untar it:
tar -xvzf v1.0.tar.gz
cd OpenConext-deploy-2.0
./provision-vagrant
```

When the script is done, wait a little while to let all services come up and initialize themselves. Then point your browser to [https://welcome.vm.openconext.org](https://welcome.vm.openconext.org)

These are the steps the above script performs:

1. Setup a Vagrant VM and will make sure the HOSTS file is able to handle the defined base_domain
2. Setup a MySQL server and LDAP for storage.
3. Inserts entities and metadata in Janus and initial load of engineblock to bootstrap.
4. Install all Java apps for the openconext platform.
5. Install all PHP apps for the openconext platform.
6. Install Haproxy for loadbalacing and SSL termination
7. Install [mujina](https://github.com/OpenConext/Mujina) as IDP and SP for the VM environment.

## Add hostname entries to your own /etc/hosts file

We need pseudo-DNS entries so that your browser can reach the VM-platform we just installed. So, add this very long line to your `/etc/hosts` file:

```
192.168.66.98  welcome.vm.openconext.org serviceregistry.vm.openconext.org static.vm.openconext.org db.vm.openconext.org ldap.vm.openconext.org engine.vm.openconext.org  profile.vm.openconext.org mujina-sp.vm.openconext.org mujina-idp.vm.openconext.org teams.vm.openconext.org grouper.vm.openconext.org authz.vm.openconext.org voot.vm.openconext.org authz-admin.vm.openconext.org authz-playground.vm.openconext.org pdp.vm.openconext.org engine-api.vm.openconext.org oidc.vm.openconext.org aa.vm.openconext.org
```

Here, the ip-address `192.168.66.98` refers to the address that is mentioned in ./Vagrantfile.

## Enjoy your new VM!

Go to [https://welcome.vm.openconext.org](https://welcome.vm.openconext.org). To ssh to the machines use the following:

```
vagrant ssh lb_centos7
vagrant ssh apps_centos7
```

(using `vagrant ssh` without a VM specified leads to the Apps VM)

The lb vm contains haproxy. The apps vm contains all the applications, apache, database and ldap.

# Releases to vm, test, acc, prod

To update single applications - e.g. release - use tags:

```
ansible-playbook -i /path/to/environmentdir/$env/inventory -u $deploy_USERNAME -K  --extra-var="secrets_file=/path_to_acc_secrets/secrets.yml" provision.yml --tags eb
```

The secrets used by Ansible are externalized. For the VM the secrets are in this GitHub repo, for test in an internal SURF repo on the build server and for acc and prod the secrets are managed by Prolocation.

# Making changes

When making changes, please consider that people are continuously deploying
vm's from master. Therefore, please do your best to keep HEAD in a working
state, and make any invasive changes like adding new components or refactoring
on a separate branch.

# License

These files are licensed under version 2.0 of the Apache License, as described in the file [LICENSE](LICENSE).

# VM

To provision the VM use the following (password is vagrant and sudo password is <enter>

```
ansible-playbook -u vagrant -i inventory/vm -K selfservice.yml -k
```

Setting up a development environment is described in the file [DEVELOPMENT](DEVELOPMENT.md).
View
