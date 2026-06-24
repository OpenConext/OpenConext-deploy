# Changelog

All notable changes to this project will be documented in this file.

### Changed
- All group_var files are moved to the environment example template, more information about where to save group_vars in the [README](https://github.com/OpenConext/OpenConext-deploy/blob/main/README.md)
- separate plays for separate roles in the provision.yml playbook
- seperate groups are defined for separate apps, dividing apps across the container servers should be set in the inventory not in the playbook, this way you can easily change it for different environments. This also makes it impossible to use the wrong tag and deploy something you did not intend to, instead nothing will happen.
- mysql_standalone group replaces storage group

### Removed
- selfsigned_certs role is deprecated and removed from the provision.yml playbook
- environment/playbook inclusion in provision.yml

### Todo
- [ ] Complete environments/template
