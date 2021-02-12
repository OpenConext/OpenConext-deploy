import os
import pytest

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


@pytest.mark.parametrize("services", [
    ("mongodb-org")
])
def test_services_running_and_enabled(host, services):
    service = host.service(services)
    assert service.is_enabled
    assert service.is_running


@pytest.mark.parametrize("services", [
    ("mongod"),
])
def test_services_running_and_enabled(host, services):
    service = host.service(services)
    assert service.is_enabled
    assert service.is_running


@pytest.mark.parametrize("files, owner, group, mode", [
    ("/usr/local/sbin/mongo_kernel_settings.sh", "root", "root", 0o700),
    ("/etc/mongod.conf", "root", "root", 0o644),
    ("/etc/logrotate.d/mongodb", "root", "root", 0o644),
])
def test_mongo_files(host, files, owner, group, mode):
    mongo_file = host.file(files)
    assert mongo_file.user == owner
    assert mongo_file.group == group
    assert mongo_file.mode == mode


def test_rc_local(host):
    tls_bundle = host.file("/etc/rc.local")

    assert tls_bundle.contains('/usr/local/sbin/mongo_kernel_settings.sh')


def test_show_databases(host):
    command = host.command('echo "show databases" | mongo -u admin -psecret | grep "GB$" | wc -l')
    assert command.rc == 0
    assert int(command.stdout) == 3
