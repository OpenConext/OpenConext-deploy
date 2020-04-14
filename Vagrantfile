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
  config.vm.box = "CentOS-7.0"
  config.vm.box_url = "https://build.openconext.org/vagrant_boxes/virtualbox-centos7.box"

  config.vm.define "lb_centos7" do |lb_centos7|
    lb_centos7.vm.network :private_network, ip: "192.168.66.98"
    lb_centos7.vm.hostname = "lb.vm.openconext.org"
    lb_centos7.vm.provider :virtualbox do |vb|
      vb.name = "OpenConext Engineblock Loadbalancer"
      vb.customize ["modifyvm", :id, "--memory", "512"]
      vb.customize ["modifyvm", :id, "--cpus", "1"]
    end

    if development == true
      # run Ansible for loadbalancer only
      lb_centos7.vm.provision :ansible do |ansible|
        ansible.limit = ["loadbalancer-vm"]
        ansible.inventory_path = "./environments/vm/inventory"
        ansible.playbook = "provision.yml"
        ansible.extra_vars = {
          user: "vagrant",
          env: "vm",
          secrets_file: "environments/vm/secrets/vm.yml",
          develop: true,
	  environment_dir: "environments/vm/"
        }
      end
    end
  end

  config.vm.define "apps_centos7", primary: true do |apps_centos7|
    apps_centos7.vm.network :private_network, ip: "192.168.66.99"
    apps_centos7.vm.hostname = "apps.vm.openconext.org"
    apps_centos7.vm.provider :virtualbox do |vb|
      vb.name = "OpenConext Engineblock Apps"
      vb.customize ["modifyvm", :id, "--memory", "4096"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
    end

    if development
      apps_centos7.vm.synced_folder ".", "/vagrant", :nfs => true
      apps_centos7.vm.synced_folder "../OpenConext-engineblock", "/opt/openconext/OpenConext-engineblock", :nfs => true

      apps_centos7.vm.provision :ansible do |ansible|
        ansible.limit = ["php-apps", "java-apps", "storage", "oidc"]
        ansible.inventory_path = "./environments/vm/inventory"
        ansible.playbook = "provision.yml"
        ansible.extra_vars = {
          user: "vagrant",
          env: "vm",
          secrets_file: "environments/vm/secrets/vm.yml",
          develop: true,
          engine_apache_symfony_environment: "dev",
	  environment_dir: "environments/vm/"
        }
      end

      apps_centos7.vm.provision :shell, privileged: false, run: "always", path: "scripts/prep-dev-env.sh"
    end

  end
end
