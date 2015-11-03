# -*- ruby -*-

Vagrant.configure("2") do |config|
  config.vm.box = "CentOS-6.5-puppet"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-nocm.box"

  config.vm.define "lb" do |lb|
    lb.vm.network :private_network, ip: "192.168.66.78"
    lb.vm.hostname = "lb.vm.openconext.org"
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
      vb.customize ["modifyvm", :id, "--cpus", "1"]
    end
  end

  config.vm.define "apps", primary: true do |apps|
    apps.vm.network :private_network, ip: "192.168.66.79"
    apps.vm.hostname = "apps.vm.openconext.org"
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end

    if ENV['ENV'] == 'develop'
        apps.vm.synced_folder "../OpenConext-engineblock", "/opt/openconext/OpenConext-engineblock"
# The reason to do this is so that we can create writeable dirs in the project under a different user (cache dir etc).
# This in turn is wanted since that allows us to use additional tooling for Symfony2 that needs the cache for introspection.
# However, this user does not exist until *after* the ansible provisioning ran - so it can't run till then :(
# Should be resolved at a later time.
#         apps.vm.provision :shell, run: "always", inline: "mount -t vboxsf -o uid=engineblock,gid=engineblock opt_engineblock /opt/openconext/OpenConext-engineblock"
    end
  end

end
