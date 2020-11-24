import os
import pytest

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


@pytest.mark.parametrize("installed_packages", [
    ("httpd"),
    ("mod_ssl"),
])
def test_packages_installed(host, installed_packages):
    rpackage = host.package(installed_packages)
    assert rpackage.is_installed


@pytest.mark.parametrize("services", [
    ("httpd"),
])
def test_services_running_and_enabled(host, services):
    service = host.service(services)
    assert service.is_enabled
    assert service.is_running


@pytest.mark.parametrize("files", [
    ("/etc/httpd/conf.d/welcome-vm.conf"),
])
def test_welcome(host, files):
    welcome = host.file(files)
    assert welcome.user == "root"
    assert welcome.group == "root"
    assert welcome.mode == 0o644


def test_http_ssl_conf(host):
    http_ssl_conf = host.file("/etc/httpd/conf.d/ssl.conf")
    assert not http_ssl_conf.contains('Listen 443')


@pytest.mark.parametrize("files", [
    ("/etc/httpd/conf.d/welcome.conf"),
    ("/etc/httpd/conf.d/userdir.conf"),
    ("/etc/httpd/conf.d/autoindex.conf"),
])
def test_empty_config(host, files):
    test_empty_config = host.file(files)
    assert test_empty_config.size == 0


def test_subject_ssll_key(host):
    cmd = host.run("openssl x509 -in  /etc/pki/tls/certs/backend.molecule.openconext.org.pem -noout -subject")
    assert 'subject= /O=OpenConext/CN=*.molecule.openconext.org' in cmd.stdout
    assert cmd.rc == 0
