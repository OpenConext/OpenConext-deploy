# -*- ruby -*-

if ENV['ENV'] == 'dev'
  development = true
end

if development
  # Define custom error with non-translated message
  class EngineBlockError < Vagrant::Errors::VagrantError
    def initialize(dir);
      @dir = dir
      super()
    end

    def error_message; "Directory " + @dir + " must exist before being able to mount OpenConext-engineblock" end
  end

  # Check if required directory exists
  _engineblock_dir = File.dirname(__FILE__) + "/../OpenConext-engineblock"
  unless Dir.exists?(_engineblock_dir)
   raise EngineBlockError.new(_engineblock_dir)
  end
end

Vagrant.configure("2") do |config|
  config.vm.box = "OpenConext-CentOS-7.0"
  config.vm.box_url = "https://build.openconext.org/vagrant_boxes/openconext.json"
  config.vm.define "apps_centos7", primary: true do |apps_centos7|
    apps_centos7.vm.network :private_network, ip: "192.168.66.99"
    apps_centos7.vm.hostname = "apps.vm.openconext.org"
    apps_centos7.vm.provider :virtualbox do |vb|
      vb.name = "OpenConext Engineblock Apps"
      vb.customize ["modifyvm", :id, "--memory", "4096"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end

    if development
      apps_centos7.vm.synced_folder "../OpenConext-engineblock", "/opt/openconext/OpenConext-engineblock", :nfs => true
      apps_centos7.vm.synced_folder ".", "/vagrant", :nfs => true
    end

  end
end
