usage for rood/blauw deployment:

an example playbook:

```
---
- name: Change loadbalancer state
  hosts: loadbalancer_ha
  become: false
  gather_facts: false
  roles:
    - { role: haproxy_mgnt, tags: ['haproxy_mgnt'] }
```

in group_vars set haproxy_applications:

```
haproxy_applications:

  - name: <APP>
    vhost_name: <APP>.{{ base_domain }}
    ha_method: "GET"
    ha_url: "/health"
    port: "{{ loadbalancing.engine.port }}"
    servers: "{{ docker_servers }}"
```

and set servers, add a color label:

```
docker_servers:
   - { ip: "<IPROOD>", label: "docker", color: "rood" }
   - { ip: "<IPBLAUW>", label: "docker", color: "blauw" }
```

run the playbook:

```
ansible-playbook -i <INVENTORY> --tags haproxy_mgnt <PLAYBOOKNAME> -e "weight=<WEIGHT>" -e "app_name=<APP>" -e app_filter=color
 -e "app_filtervalue=<COLOR>"
 ```