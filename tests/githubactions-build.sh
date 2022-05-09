#!/bin/bash

set -e

# keep exit status
status=0

ANSIBLE_PLAYBOOK=./provision.yml
ANSIBLE_INVENTORY=./environments-external/github/inventory
ANSIBLE_SECRETS=./environments-external/github/secrets/vm.yml
ANSIBLE_PLAYBOOK_WRAPPER=./provision
ANSIBLE_USER=root

# start docker container
docker run --detach                                         \
	-v /sys/fs/cgroup:/sys/fs/cgroup:ro                     \
	-t                                                      \
	--privileged                                            \
	--publish 443:443                                       \
	--name ansible-test-ga                                  \
	--add-host static.vm.openconext.org:127.0.0.1           \
	--add-host metadata.vm.openconext.org:127.0.0.1         \
	--add-host engine.vm.openconext.org:127.0.0.1           \
	--add-host profile.vm.openconext.org:127.0.0.1          \
	--add-host mujina-sp.vm.openconext.org:127.0.0.1        \
	--add-host mujina-idp.vm.openconext.org:127.0.0.1       \
	--add-host teams.vm.openconext.org:127.0.0.1            \
	--add-host voot.vm.openconext.org:127.0.0.1             \
	--add-host db.vm.openconext.org:127.0.0.1               \
	--add-host pdp.vm.openconext.org:127.0.0.1              \
	--add-host engine-api.vm.openconext.org:127.0.0.1       \
	--add-host aa.vm.openconext.org:127.0.0.1               \
	--add-host link.vm.openconext.org:127.0.0.1             \
	--add-host connect.vm.openconext.org:127.0.0.1          \
	--add-host oidc-playground.vm.openconext.org:127.0.0.1  \
	--add-host manage.vm.openconext.org:127.0.0.1           \
	--add-host redirect.vm.openconext.org:127.0.0.1         \
	--add-host localhost:127.0.0.1                          \
	--add-host ansible-test-ga:127.0.0.1                          \
	--hostname test.openconext.org                          \
	-e TERM=xterm                                           \
	surfnet/centos7-openconext-ga

# initialize ansible.cfg
cat <<-'EOF' > ansible.cfg
	[defaults]
	callback_whitelist=profile_tasks
	[ssh_connection]
	ssh_args=-o ControlMaster=auto -o ControlPersist=60m
	pipelining=True
EOF

# Prepare the environment
echo "Prepping the environment" 
mkdir -p environments-external
/bin/cp -r environments/vm/ environments-external/github
/bin/mv environments-external/github/group_vars/vm.yml environments-external/github/group_vars/github.yml
sed -i 's/192.168.66.98/0.0.0.0/g' environments-external/github/group_vars/github.yml
sed -i 's/192.168.66.99/127.0.0.1/g' environments-external/github/group_vars/github.yml
# Change the hostname in the inventory
/bin/cp environments/template/inventory environments-external/github/
sed -i 's/%env%/github/g' environments-external/github/inventory
sed -i 's/%target_host%/ansible-test-ga ansible_connection=docker/g' environments-external/github/inventory 

# Create the proper host_vars file
/bin/cp environments/template/host_vars/template.yml environments-external/github/host_vars/ansible-test-ga.yml

# Remove ipv6 listening address in Haproxy
sed -i '/haproxy_sni_ip\.ipv6/d' roles/haproxy/templates/haproxy_frontend.cfg.j2
echo
echo "================================================================="
echo "================================================================="
echo "== STARTING MAIN PLAYBOOK RUN ==================================="
echo "================================================================="
echo "================================================================="
echo

./provision github $ANSIBLE_USER $ANSIBLE_SECRETS -e springboot_service_to_deploy=teams,voot,oidcng,manage,mujina-sp,mujina-idp -e @tests/github.yml -t core

# Make the image a bit smaller
docker exec ansible-test-ga systemctl stop mysql mongod
docker exec ansible-test-ga yum -y remove mongodb-org-mongos mongodb-org-tools
docker exec ansible-test-ga rm -rf /var/lib/mongo/journal/*
docker exec ansible-test-ga rm -rf /var/lib/mysql/ib_logfile*

# The latest systemd update breaks mongo on docker (systemd[1]: New main PID 951 does not belong to service, and PID file is not owned by root. Refusing)
# dowgrading it fixes the issue
docker exec ansible-test-ga yum -y downgrade http://vault.centos.org/7.6.1810/updates/x86_64/Packages/systemd-219-62.el7_6.9.x86_64.rpm http://vault.centos.org/7.6.1810/updates/x86_64/Packages/systemd-libs-219-62.el7_6.9.x86_64.rpm http://vault.centos.org/7.6.1810/updates/x86_64/Packages/systemd-sysv-219-62.el7_6.9.x86_64.rpm

docker stop ansible-test-ga ansible-test-ga

exit $status
