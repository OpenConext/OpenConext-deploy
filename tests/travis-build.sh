#!/bin/bash

set -e

# keep exit status
status=0

ANSIBLE_CONFIG=/ansible/ansible.cfg
ANSIBLE_PLAYBOOK=/ansible/provision-vm.yml
ANSIBLE_INVENTORY=/ansible/environments/docker/inventory
ANSIBLE_SECRETS=/ansible/environments/vm/secrets/vm.yml


# start docker container
docker run --detach                                         \
	-v "${PWD}":/ansible:rw                                 \
	-v /sys/fs/cgroup:/sys/fs/cgroup:ro                     \
	--privileged                                            \
	--name ansible-test                                     \
	--add-host static.vm.openconext.org:127.0.0.1           \
	--add-host metadata.vm.openconext.org:127.0.0.1         \
	--add-host serviceregistry.vm.openconext.org:127.0.0.1  \
	--add-host engine.vm.openconext.org:127.0.0.1           \
	--add-host profile.vm.openconext.org:127.0.0.1          \
	--add-host mujina-sp.vm.openconext.org:127.0.0.1        \
	--add-host mujina-idp.vm.openconext.org:127.0.0.1       \
	--add-host teams.vm.openconext.org:127.0.0.1            \
	--add-host authz.vm.openconext.org:127.0.0.1            \
	--add-host authz-admin.vm.openconext.org:127.0.0.1      \
	--add-host authz-playground.vm.openconext.org:127.0.0.1 \
	--add-host voot.vm.openconext.org:127.0.0.1             \
	--add-host lb.vm.openconext.org:127.0.0.1               \
	--add-host apps.vm.openconext.org:127.0.0.1             \
	--add-host db.vm.openconext.org:127.0.0.1               \
	--add-host pdp.vm.openconext.org:127.0.0.1              \
	--add-host engine-api.vm.openconext.org:127.0.0.1       \
	--add-host aa.vm.openconext.org:127.0.0.1               \
	--add-host link.vm.openconext.org:127.0.0.1             \
	--add-host oidc.vm.openconext.org:127.0.0.1             \
	--add-host manage.vm.openconext.org:127.0.0.1           \
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

echo
echo "================================================================="
echo "================================================================="
echo "== STARTING SYNTAX CHECK ========================================"
echo "================================================================="
echo "================================================================="
echo

docker exec -t ansible-test                                      \
	ansible-playbook                                             \
		-i $ANSIBLE_INVENTORY                                    \
		-e secrets_file=$ANSIBLE_SECRETS                         \
		$ANSIBLE_PLAYBOOK                                        \
		--syntax-check

echo
echo "================================================================="
echo "================================================================="
echo "== STARTING MAIN PLAYBOOK RUN ==================================="
echo "================================================================="
echo "================================================================="
echo

docker exec -t ansible-test                                      \
	ansible-playbook                                             \
		-i $ANSIBLE_INVENTORY                                    \
		-e secrets_file=$ANSIBLE_SECRETS                         \
		$ANSIBLE_PLAYBOOK

echo
echo "================================================================="
echo "================================================================="
echo "== STARTING IDEMPOTENCY TEST ===================================="
echo "================================================================="
echo "================================================================="
echo

TMPOUT=$(mktemp)
docker exec -t ansible-test                                      \
	ansible-playbook                                             \
		-i $ANSIBLE_INVENTORY                                    \
		-e secrets_file=$ANSIBLE_SECRETS                         \
		$ANSIBLE_PLAYBOOK                                        \
 | tee $TMPOUT

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
		/ansible/tests/all_services_are_up.yml

exit $status
