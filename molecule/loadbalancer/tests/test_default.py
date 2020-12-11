import os
import pytest

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


@pytest.mark.parametrize("installed_packages", [
    ("haproxy20"),
    ("socat"),
    ("keepalived"),
    ("bind"),
])
def test_packages_installed(host, installed_packages):
    rpackage = host.package(installed_packages)
    assert rpackage.is_installed


@pytest.mark.parametrize("services", [
    ("haproxy"),
    # ("keepalive"),
    ("named"),
])
def test_services_running_and_enabled(host, services):
    service = host.service(services)
    assert service.is_enabled
    assert service.is_running


@pytest.mark.parametrize("files", [
    ("/etc/pki/haproxy/star_haproxy.pem"),
])
def test_star_haproxy_pem(host, files):
    star_haproxy_pem = host.file(files)
    assert star_haproxy_pem.user == "root"
    assert star_haproxy_pem.group == "root"
    assert star_haproxy_pem.mode == 0o600

    assert star_haproxy_pem.contains('-----BEGIN CERTIFICATE-----')
    assert star_haproxy_pem.contains('-----BEGIN RSA PRIVATE KEY-----')


def test_sysctl_non_local_bind(host):
    non_local_bind = host.sysctl("net.ipv4.ip_nonlocal_bind")
    assert non_local_bind == 1
