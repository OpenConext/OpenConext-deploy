# -*- ruby -*-

Vagrant.configure("2") do |config|
  config.vm.box = "CentOS-6.5-puppet"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-nocm.box"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.define "openconext-java" do |selfservice|
    selfservice.vm.network :private_network, ip: "192.168.66.78"
    selfservice.vm.provision :ansible do |ansible|
      ansible.playbook = "openconext-java.yml"
      ansible.inventory_path = "inventory/vm"
    end
  end

end
