import os
import pytest

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


@pytest.mark.parametrize("installed_packages", [
    ("MariaDB-server"),
    ("MariaDB-client"),
    ("MySQL-python"),
    ("galera"),
])
def test_packages_installed(host, installed_packages):
    rpackage = host.package(installed_packages)
    assert rpackage.is_installed


@pytest.mark.parametrize("services", [
    ("mariadb"),
])
def test_services_running_and_enabled(host, services):
    service = host.service(services)
    assert service.is_enabled
    assert service.is_running


@pytest.mark.parametrize("files", [
    ("/etc/pki/mysql/galera_client.key"),
    ("/etc/pki/mysql/galera_server.key"),
    ("/etc/pki/mysql/galera_server.pem"),
    ("/etc/pki/mysql/galera_sst.pem"),
])
def test_galera_tls(host, files):
    file = host.file(files)
    assert file.user == "mysql"
    assert file.group == "root"
    assert file.mode == 0o400


def test_create_test_database(host):
    ansible_vars = host.ansible.get_variables()
    current_hostname = ansible_vars['inventory_hostname']
    if current_hostname == 'openconext-centos7-mysql':
        host.command('mysql -e "drop database if exists moleculetest"')
        command = host.command('mysql -e "create database moleculetest;"')
        assert command.rc == 0


def test_show_databases(host):
    command = host.command('mysql -e "show databases;" | grep -q moleculetest | wc -l')
    assert command.rc == 0
    assert int(command.stdout) == 1


def test_create_test_database(host):
    ansible_vars = host.ansible.get_variables()
    current_hostname = ansible_vars['inventory_hostname']
    if current_hostname == 'openconext-centos7-mysql':
        command = host.command('mysql -e "drop database if exists moleculetest"')
        assert command.rc == 0


def test_show_databases(host):
    command = host.command('mysql -e "show databases;" | grep -q moleculetest | wc -l')
    assert command.rc == 0
    assert int(command.stdout) == 0
