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

It is also possible to deploy using Vagrant and libvirt/qemu (on Linux).
Instructions are provided below.

## Install Vagrant and VirtualBox

VirtualBox is a powerful x86 and AMD64/Intel64 virtualization product, downloads and user manual can be found on the [VirtualBox website](https://www.virtualbox.org/wiki/Downloads).
> Vagrant provides easy to configure, reproducible, and portable work environments built on top of industry-standard technology and controlled by a single consistent workflow to help maximize the productivity and flexibility of you and your team.

For installation instructions see [the website](https://docs.vagrantup.com/v2/installation/index.html).

You will need at least Vagrant 1.7. Do not use Vagrant 1.8.5, which contains a bug that makes that the provisioning fails with the message "Warning: Authentication failure. Retrying...".  Also, more recent versions (around 1.9.1) have problems detecting the network devices inside the VM, causing vagrant to fail to connect using ssh.

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
The minimum required version of Ansible is 1.9. Version 2.4 and higher are not yet supported. Please use 2.3 or lower. 
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
Clone the repository:
git clone https://github.com/OpenConext/OpenConext-deploy.git
cd OpenConext-deploy
./provision-vagrant
```

When the script is done, wait a little while to let all services come up and initialize themselves. Then point your browser to [https://welcome.vm.openconext.org](https://welcome.vm.openconext.org)

These are the steps the above script performs:

1. Setup a Vagrant VM and will make sure the HOSTS file is able to handle the defined base_domain
2. Setup a MariaDB server.
3. Inserts entities and metadata in Janus and initial load of engineblock to bootstrap.
4. Install all Java apps for the openconext platform.
5. Install all PHP apps for the openconext platform.
6. Install Haproxy for loadbalacing and SSL termination
7. Install [mujina](https://github.com/OpenConext/Mujina) as IDP and SP for the VM environment.

## Add hostname entries to your own /etc/hosts file

We need pseudo-DNS entries so that your browser can reach the VM-platform we just installed. So, add this very long line to your `/etc/hosts` file:

```
192.168.66.98  welcome.vm.openconext.org serviceregistry.vm.openconext.org static.vm.openconext.org metadata.vm.openconext.org db.vm.openconext.org engine.vm.openconext.org  profile.vm.openconext.org mujina-sp.vm.openconext.org mujina-idp.vm.openconext.org teams.vm.openconext.org authz.vm.openconext.org voot.vm.openconext.org authz-admin.vm.openconext.org authz-playground.vm.openconext.org pdp.vm.openconext.org engine-api.vm.openconext.org oidc.vm.openconext.org aa.vm.openconext.org link.vm.openconext.org manage.vm.openconext.org
```

Here, the ip-address `192.168.66.98` refers to the address that is mentioned in ./Vagrantfile.

## Enjoy your new VM!

Go to [https://welcome.vm.openconext.org](https://welcome.vm.openconext.org). To ssh to the machines use the following:

```
vagrant ssh lb_centos7
vagrant ssh apps_centos7
```

(using `vagrant ssh` without a VM specified leads to the Apps VM)

The lb vm contains haproxy. The apps vm contains all the applications, apache and database.

## Deploy using libvirt/qemu

Instead of using Virtualbox as described above, it is also possible to use libvirt/qemu on Linux
machines.  This requires a number of additional steps.

1. Make sure you have a recent version of vagrant, and that libvirt/qemu is
   working as expected for normal VMs (e.g., check if virt-manager works
   correctly to create a new VM).
2. Install the `vagrant-libvirt` and `vagrant-mutate` plugins:

```
╰─▶ vagrant plugin install vagrant-libvirt
╰─▶ vagrant plugin install vagrant-mutate
```
   (or use the version provided by your distribution).
3. Download the Openconext base CentOS7 image.  This is a Virtualbox-image, so
   it needs to be converted to a libvirt-image using `vagrant mutate`:
```
╰─▶ vagrant box add https://build.openconext.org/vagrant_boxes/virtualbox-centos7.box --name CentOS-7.0
╰─▶ vagrant mutate CentOS-7.0 libvirt --force-virtio
```
4. Vagrant should now have two variants of the CentOS-7.0 image:
```
╰─▶ vagrant box list
CentOS-7.0 (libvirt, 0)
CentOS-7.0 (virtualbox, 0)
```
5. From a checked-out version of the OpenConext-deploy repository, run the
   following command to check if the boxes come up:
```
╰─▶ vagrant up --provider libvirt lb_centos7
╰─▶ vagrant up --provider libvirt apps_centos7
```
(set the environment variable `VAGRANT_LOG=debug` to increase verbosity of
anything goes wrong.
6. You should be set to run the `provision-vagrant script`.



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
ansible-playbook -u vagrant -i ./environments/vm/inventory -K --e secrets_file=./environments/vm/secrets/vm.yml provision-vm.yml
```
To provision a certain role use tags:
```
ansible-playbook -u vagrant -i ./environments/vm/inventory -K --e secrets_file=./environments/vm/secrets/vm.yml provision-vm.yml --tags vm_only_provision_manage_eb
```

Setting up a development environment is described in the file [DEVELOPMENT](DEVELOPMENT.md).

