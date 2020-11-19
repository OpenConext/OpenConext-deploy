import os
import pytest

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


@pytest.mark.parametrize("services", [
    ("ntpd"),
    ("postfix")
])
def test_services_running_and_enabled(host, services):
    zabbix = host.service(services)
    assert zabbix.is_enabled
    assert zabbix.is_running


@pytest.mark.parametrize("removed_packages", [
    ("exim"),
    ("sendmail"),
    ("sendmail-cf"),
])
def test_packages_removed(host, removed_packages):
    rpackage = host.package(removed_packages)
    assert not rpackage.is_installed


@pytest.mark.parametrize("files, owner, group, mode", [
    ("/etc/pki/tls/private/star.vm.openconext.org.key", "root", "root", 0o600),
    ("/etc/pki/tls/certs/star.vm.openconext.org.pem", "root", "root", 0o644),
])
def test_openconext_star_files(host, files, owner, group, mode):
    openconext_star = host.file(files)
    assert openconext_star.user == owner
    assert openconext_star.group == group
    assert openconext_star.mode == mode


def test_tls_bundle(host):
    tls_bundle = host.file("/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem")
    assert tls_bundle.mode == 0o444

    assert tls_bundle.contains('*.vm.openconext.org')
