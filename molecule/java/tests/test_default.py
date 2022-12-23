import os
import pytest

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')



def test_java_binary(host):
    java_binary = host.file("/usr/bin/java")
    command = host.run('/usr/bin/java -version 2>&1 | grep openjdk')
    assert java_binary.exists
    assert java_binary.is_file

    assert command.rc == 0
    assert 'version "11.' in command.stdout


@pytest.mark.parametrize("components, dir_owner, file_owner, group, httpd_listen, spring_listen", [
    ("manage", "root", "manage", "root", "617", "9393"),
    ("mujina-idp", "mujina-idp", "mujina-idp", "mujina-idp", "608", "9390"),
    ("mujina-sp", "mujina-sp", "mujina-sp", "mujina-sp", "607", "9391"),
])
def test_components(host, components, dir_owner, file_owner, group, httpd_listen, spring_listen):
    user = host.user(components)
    service = host.service(components)
    socket_httpd = host.socket("tcp://127.0.0.1:" + httpd_listen)
    socket_springboot = host.socket("tcp://127.0.0.1:" + spring_listen)
    opt_dir = host.file("/opt/" + components)
    logback = host.file("/opt/" + components + "/logback.xml")
    application = host.file("/opt/" + components + "/application.yml")
    http_file = host.file("/etc/httpd/conf.d/" + components.replace("-", "_") + '.conf')
    # manage contains a version in symlink, so lets skip that for now.
    if components != "manage":
        jar_file = host.file("/opt/" + components + "/" + components + '.jar')
        assert jar_file.is_symlink

    assert user.exists

    assert service.is_enabled
    assert service.is_running

    assert opt_dir.is_directory
    assert opt_dir.user == dir_owner
    assert opt_dir.group == group

    assert logback.exists
    assert logback.user == file_owner
    assert application.exists
    assert application.user == file_owner

    assert http_file.exists
    assert http_file.is_file

    assert socket_httpd.is_listening
    assert socket_springboot.is_listening
