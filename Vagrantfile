# -*- ruby -*-

Vagrant.configure("2") do |config|
  config.vm.box = "CentOS-7.0-puppet"
  config.vm.box_url = "https://github.com/holms/vagrant-centos7-box/releases/download/7.1.1503.001/CentOS-7.1.1503-x86_64-netboot.box" 

  config.vm.define "lb_centos7" do |lb_centos7|
    lb_centos7.vm.network :private_network, ip: "192.168.66.98"
    lb_centos7.vm.hostname = "lb.vm.openconext.org"
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "512"]
      vb.customize ["modifyvm", :id, "--cpus", "1"]
    end
  end

  config.vm.define "apps_centos7" do |apps_centos7|
    apps_centos7.vm.network :private_network, ip: "192.168.66.99"
    apps_centos7.vm.hostname = "apps.vm.openconext.org"
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "4096"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
  end

end
