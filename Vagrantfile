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

  config.vm.define "apps" do |apps|
    apps.vm.network :private_network, ip: "192.168.66.79"
    apps.vm.hostname = "apps.vm.openconext.org"
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "3072"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
  end

end
