# -*- ruby -*-

Vagrant.configure("2") do |config|
  config.vm.box = "CentOS-7.0"
  config.vm.box_url = "https://build.surfconext.nl/vagrant_boxes/virtualbox-centos7.box"

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
      vb.customize ["modifyvm", :id, "--memory", "3072"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
  end

end
