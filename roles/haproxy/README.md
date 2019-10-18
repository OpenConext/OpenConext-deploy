# Haproxy role

## Introduction
The haproxy role of OpenConext will install an Haproxy loadbalancer in front of all the OpenConext applications. It terminates TLS, and can connect to backends using either https or http. 

The Haproxy instance will run on two different ip addresses: This enables you to apply different firewall rules to different applications, eg to protect the administration interfaces from being publicly accessable. 

Configuration is done in the group_vars. See below for an explanation of what you can change. The defaults in the template directory (/environments/template/group_vars/template.yml) should get you a working Haproxy instance.

## Variables

All apps that are served by Haproxy go into the list "haproxy_applications". The the template environment for a complete list. A sample from that:

```
haproxy_applications:

  - name: engine
    vhost_name: engine.{{ base_domain }}
    port: "{{ loadbalancing.engine.port }}"
    ha_method: "GET"
    ha_url: "/health"
    servers: "{{ php_servers }}"

  - name: manage
    vhost_name: manage.{{ base_domain }}
    ha_method: "GET"
    ha_url: "/health"
    port: "{{ loadbalancing.manage.port }}"
    servers: "{{ php_servers }}"
    sslbackend: yes
    backend_vhost_name: backend.myapp.tld
    backend_ca_file: "/etc/pki/tls/certs/ca-bundle.crt"
    restricted: yes

  - etc...
```

As you can see, you can configure several elements in that list:

name: The name is obligatory. 
vhost_name: This is the hostname of the application (eg engine.yourdomain.tld). 
port: This is the port that the backend server listens on. 
ha_url: The url used to check the health of the backend application. If it is not reachable, or it gives an HTTP error that backend will be marked down. For most applications that defaults to /health
ha_method: The http method used in the health check. 
servers: A list of the servers that is used for  this application. 
restricted: If it is present and set to "yes" the application will be served from te restricted IP address. 
sslbackend: If it is present and set to "yes" the backend connection will be performed over https. 
backend_vhost_name: If you have enabled "sslbackend" you need to configure the backend vhost name as well (which should also be present in the certificate on the backend"
backend_ca_file: If you have enabled "sslbackend" you can use your own CA. Configure that here

The backend servers can be in a list as well. If you have two servers in "{{ php_servers }}":
```
php_servers:
   - { ip: "192.168.66.20", label: "phpapps1"}
   - { ip: "192.168.66.21", label: "phpapps2"}
```
This would create two backend servers. You can add as many backend servers as you like

The ipaddresses and certificates go into two lists (sample taken from the template):
```
haproxy_sni_ip:
  ipv4: 127.0.0.1
  ipv6:  "::1"
  certs: 
     - name: star
       key_content: "{{ https_star_private_key }}"
       crt_name: star.{{ base_domain }}.pem

haproxy_sni_ip_restricted:
  ipv4: 127.0.0.2
  ipv6: "::1"
  certs:
     - name: star
       key_content: "{{ https_star_private_key }}"
       crt_name: star.{{ base_domain }}.pem
```


haproxy_sni_ip: is the public ip address, haproxy_sni_ip_restricted is the second ip addresss. All apps that have the boolean "restricted" set to "yes" will be served from that ip address. You can also leave that ip address out i you need only one ipaddress.
The following elements can be configured:
ipv4: The ipv4 address
ipv6: The ipv6 address:
certs: A list of certificates that you use for https. That list contains these parameters:
 name: A name for your certificate
 key_content: You can add your https key in this parameter, and add it to your secrets. See environments/vm/secrets/vm.yml for an example
 crt_name: The certificate is placed in your environments directory: In files/certs/. The filename should match "crt_name"















