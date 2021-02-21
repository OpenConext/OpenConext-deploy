#!/bin/bash

set -e

# keep exit status
status=0

ANSIBLE_PLAYBOOK=./provision.yml
ANSIBLE_INVENTORY=./environments-external/github/inventory
ANSIBLE_SECRETS=./environments-external/github/secrets/github.yml
ANSIBLE_PLAYBOOK_WRAPPER=./provision
ANSIBLE_USER=root

# start docker container
docker run --detach                                         \
	-v /sys/fs/cgroup:/sys/fs/cgroup:ro                     \
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
	--add-host engine-api.vm.openconext.org:127.0.0.2       \
	--add-host aa.vm.openconext.org:127.0.0.1               \
	--add-host link.vm.openconext.org:127.0.0.1             \
	--add-host connect.vm.openconext.org:127.0.0.1          \
	--add-host oidc-playground.vm.openconext.org:127.0.0.1  \
	--add-host manage.vm.openconext.org:127.0.0.1           \
	--add-host redirect.vm.openconext.org:127.0.0.1         \
	--add-host localhost:127.0.0.1                          \
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
./prep-env github vm.openconext.org
echo "Prepping the environment" 
# Change the hostname in the inventory
sed -i 's/%target_host%/ansible-test-ga ansible_connection=docker/g' environments-external/github/inventory 

# Enable oidc-ng (When doing a -t core those tasks should not be performed)
# echo "manage_show_oidc_rp_tab: true" >> environments-external/github/group_vars/github.yml
# echo "manage_exclude_oidc_rp_imports_in_push: true" >> environments-external/github/group_vars/github.yml
# sed -i 's/oidc_push_enabled: false/oidc_push_enabled: true/g' environments-external/github/group_vars/github.yml

# Create the proper host_vars file
mv environments-external/github/host_vars/template.yml environments-external/github/host_vars/ansible-test-ga.yml

echo
echo "================================================================="
echo "================================================================="
echo "== STARTING SYNTAX CHECK ========================================"
echo "================================================================="
echo "================================================================="
echo

./provision github $ANSIBLE_USER $ANSIBLE_SECRETS --syntax-check -e @tests/github.yml

echo
echo "================================================================="
echo "================================================================="
echo "== STARTING MAIN PLAYBOOK RUN ==================================="
echo "================================================================="
echo "================================================================="
echo

./provision github $ANSIBLE_USER $ANSIBLE_SECRETS -e springboot_service_to_deploy=manage,mujina-sp,mujina-idp -e @tests/github.yml -t core

echo
echo "================================================================="
echo "================================================================="
echo "== STARTING IDEMPOTENCY TEST ===================================="
echo "================================================================="
echo "================================================================="
echo

TMPOUT=$(mktemp)
./provision github $ANSIBLE_USER $ANSIBLE_SECRETS -e springboot_service_to_deploy=manage,mujina-sp,mujina-idp -e @tests/github.yml -t core | tee $TMPOUT

echo
echo "================================================================="
echo "================================================================="
if grep -q 'changed=0.*failed=0' $TMPOUT
then
	echo "== IDEMPOTENCY CHECK: PASS ======================================"
else
	echo "== IDEMPOTENCY CHECK: FAILED! ==================================="
	status=1
fi
echo "================================================================="
echo "================================================================="
echo

# Make the image a bit smaller
docker exec systemctl stop mysql mongod
docker exec yum remove mongodb-org-mongos mongodb-org-tools
docker exec rm -rf /var/lib/mongo/journal/*
docker exec rm -rf /var/lib/mysql/ib_logfile*
docker stop ansible-test-ga



exit $status
