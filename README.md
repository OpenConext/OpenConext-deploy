Ansible-driven provisioning the OpenConext platform.
==============================

# Getting started - development mode

## Install Vagrant and VirtualBox (for Mac users)

    brew tap caskroom/cask
    brew install brew-cask
    brew cask install vagrant
    brew cask install virtualbox

## Install Ansible

Ansible is the configuration tool we use to describe our servers. To
install for development:

    brew install python
    pip install --upgrade setuptools
    pip install --upgrade pip
    brew linkapps
    brew install ansible
    pip install python-keyczar==0.71c


This playbook uses a custom vault, defined in filter_plugins/custom_plugins.py in order to encrypt data. We think this is a better solution than the ansible-vault because it allows us to do fine grained encryption instead of a big ansible-vault file.
Also, the creator of ansible-vault admits his solution is not the way to go. See [this blogpost](http://jpmens.net/2014/02/22/my-thoughts-on-ansible-s-vault/).

Retrieve the openconext-keystore from a colleague and put it on an encrypted disk partition, to keep it safe even in case of laptop-loss. Here's how to [create an encrypted folder](http://apple.stackexchange.com/questions/129720/how-can-i-encrypt-a-folder-in-os-x-mavericks) on your Mac.

This is how the keystore is created (you don't have to do this because it already exists for this project). See [this blogpost](http://www.saltycrane.com/blog/2011/10/notes-using-keyczar-and-python/) for example.

`keyczart create --location=./openconext-unsafe-keystore --purpose=crypt`

`keyczart addkey --location=./openconext-unsafe-keystore --status=primary`

Create the symlink so that our playbook can find the AES key on your encrypted volume:

`ln -s $CURRENT_DIR/openconext-unsafe-keystore ~/.openconext-keystore`

## Structure ##
The main playbooks are `openconext-php.yml` and `openconext-java.yml`. Its inventories are kept in `environments`. In that directory, a directory is made for each environment that we provision (e.g. vm, test, prod). In each of those is a group_vars folder that containst variable definitions, and the inventory file.

## Target-environment setup ##

The war-files for each app are put in their right place, inside tomcat6. That Tomcat only binds to localhost. Apache is used with mod_ssl and mod_proxy to manage virtualhosts, access logging etc.

## Environments ##

 - vm: your local vagrant vm
