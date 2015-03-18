# -*- ruby -*-

Vagrant.configure("2") do |config|
  config.vm.box = "CentOS-6.5-puppet"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-nocm.box"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.define "openconext-vm" do |openconext_vm|
    openconext_vm.vm.network :private_network, ip: "192.168.66.78"
  end

end
