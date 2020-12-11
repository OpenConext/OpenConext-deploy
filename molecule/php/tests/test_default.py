import os
import pytest

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


@pytest.mark.parametrize("installed_packages", [
    ("httpd"),
    ("php72-php-fpm"),
    ("php72-php-mysqlnd"),
])
def test_packages_installed(host, installed_packages):
    rpackage = host.package(installed_packages)
    assert rpackage.is_installed


@pytest.mark.parametrize("services", [
    ("httpd"),
    ("php72-php-fpm"),
])
def test_services_running_and_enabled(host, services):
    service = host.service(services)
    assert service.is_enabled
    assert service.is_running


@pytest.mark.parametrize("files", [
    ("/etc/opt/remi/php72/php.d/40-apcu.ini"),
    ("/etc/opt/remi/php72/php.d/openconext.ini"),
    ("/etc/opt/remi/php72/php-fpm.conf"),
    ("/etc/opt/remi/php72/php-fpm.d/www.conf"),
    ("/etc/httpd/conf.d/metadata.conf"),
    ("/etc/httpd/conf.d/static.conf"),
])
def test_php_files(host, files):
    php_file = host.file(files)
    assert php_file.user == "root"
    assert php_file.group == "root"
    assert php_file.mode == 0o644


@pytest.mark.parametrize("components", [
    ("engine"),
])
def test_components(host, components):
    component = host.user(components)
    assert component.exists
