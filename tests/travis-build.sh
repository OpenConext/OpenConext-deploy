#!/bin/bash

set -e

# keep exit status
status=0

ANSIBLE_CONFIG=/ansible/ansible.cfg
ANSIBLE_PLAYBOOK=/ansible/provision.yml
ANSIBLE_INVENTORY=/ansible/environments-external/travis/inventory
ANSIBLE_SECRETS=/ansible/environments-external/travis/secrets/travis.yml
ANSIBLE_PLAYBOOK_WRAPPER=/ansible/provision
ANSIBLE_USER=vagrant

# start docker container
docker run --detach                                         \
	-v "${PWD}":/ansible:rw                                 \
	-v /sys/fs/cgroup:/sys/fs/cgroup:ro                     \
	--privileged                                            \
	--name ansible-test                                     \
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
	-e ANSIBLE_CONFIG=${ANSIBLE_CONFIG}                     \
	surfnet/centos7-openconext

# initialize ansible.cfg
cat <<-'EOF' > /tmp/ansible.cfg
	[defaults]
	callback_plugins=/ansible/callback_plugins
	callback_whitelist=profile_tasks
	[ssh_connection]
	ssh_args=-o ControlMaster=auto -o ControlPersist=60m
	pipelining=True
EOF
# and copy it into the container
docker cp /tmp/ansible.cfg ansible-test:${ANSIBLE_CONFIG}

# Prepare the environment
./prep-env travis vm.openconext.org

# Change the hostname in the inventory
sed -i 's/%target_host%/localhost ansible_connection=local/g' environments-external/travis/inventory 

# Listen to all interfaces, so we can run a Docker container on our hosts
echo "listen_address_ip4: 0.0.0.0" >> environments-external/travis/group_vars/travis.yml

# The docker image doesn't have ipv6: Disable it for postfix
echo "postfix_interfaces: ipv4" >> environments-external/travis/group_vars/travis.yml

# Do not install Dashboard
echo "dashboard_install: False" >> environments-external/travis/group_vars/travis.yml

# Enable oidc-ng (When doing a -t core those tasks should not be performed)
# echo "manage_show_oidc_rp_tab: true" >> environments-external/travis/group_vars/travis.yml
# echo "manage_exclude_oidc_rp_imports_in_push: true" >> environments-external/travis/group_vars/travis.yml
# sed -i 's/oidc_push_enabled: false/oidc_push_enabled: true/g' environments-external/travis/group_vars/travis.yml

# Create the proper host_vars file
mv environments-external/travis/host_vars/template.yml environments-external/travis/host_vars/localhost.yml

echo
echo "================================================================="
echo "================================================================="
echo "== STARTING SYNTAX CHECK ========================================"
echo "================================================================="
echo "================================================================="
echo

docker exec -w /ansible -t ansible-test  /ansible/provision travis $ANSIBLE_USER $ANSIBLE_SECRETS --syntax-check -e @/ansible/tests/travis.yml

echo
echo "================================================================="
echo "================================================================="
echo "== STARTING MAIN PLAYBOOK RUN ==================================="
echo "================================================================="
echo "================================================================="
echo

docker exec -w /ansible -t ansible-test  /ansible/provision travis $ANSIBLE_USER $ANSIBLE_SECRETS -e springboot_service_to_deploy=manage,mujina-sp,mujina-idp -e @/ansible/tests/travis.yml -t core

echo
echo "================================================================="
echo "================================================================="
echo "== STARTING IDEMPOTENCY TEST ===================================="
echo "================================================================="
echo "================================================================="
echo

TMPOUT=$(mktemp)
docker exec -w /ansible -t ansible-test  /ansible/provision travis $ANSIBLE_USER $ANSIBLE_SECRETS -e springboot_service_to_deploy=manage,mujina-sp,mujina-idp -e @/ansible/tests/travis.yml -t core | tee $TMPOUT

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

docker exec -t ansible-test                                      \
	ansible-playbook                                             \
		-i $ANSIBLE_INVENTORY                                    \
		/ansible/tests/all_services_are_up.yml -t core

exit $status
