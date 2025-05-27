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
    port: "443"
    ha_method: "GET"
    ha_url: "/health"
    servers: "{{ php_servers }}"

  - name: manage
    vhost_name: manage.{{ base_domain }}
    ha_method: "GET"
    ha_url: "/health"
    port: "443"
    servers: "{{ php_servers }}"
    stagingservers: "{{ staging_servers }}"
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
stagingservers (optional): A list of the servers that is used for staging an application. If the cookie staging=true is present, this staging server is used as backend. 
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

## Sectigo ACME certificates
Certificates can also be automatically obtained and renewed using the ACME protocol. Currently Sectigo is hardcoded. The method used to authenticate is external account binding. For it to work you need to create a Sectigo EAB account, and assign the domains that you need in the certificate.
This roles installs acme.sh, which takes care of the certificate process. acme.sh is chosen since it has native Haproxy support: It will automatically add the certificate to haproxy and loads it into Haproxy using the admin socket. 
The SAN domains that are added to the certificate are automatically resolved from the haproxy_applications configurable parameter. For each backend it finds the vhost_name and adds it to the list. The "hostname" attribute in the haproxy_redirects configurable parameter is also added to the list. acme.sh installs a cronjob that checks every day if the certificate needs to be renewed. The default period after which the certificate is renewed is 60 days.  


## Rate limiting
The frontend has a limit that is configurable for the amount of requests per 10s. The rationale is that you want to stop sudden bursts of requests fired by clients, and you want to be quick enough to block it, before your backends are saturated. The default is 1000 requests per 10s. In our logs, we observed some NAT gateways of larger instutitions that were able to generate more than 500 legitimate requests per 10s. All rates above 1000 per 10s seemed to be coming from bots, scrapers, or misbehaving clients.
If you want to exclude ip's (either in cidr notation, or single ip addresses) from the limit, you can add them to your configuration under ```haproxy_allowlistips```. Suppose you want to put the ip address 1.1.1.1 and the ip addres 2.2.2.2 to the allowlist, you can do so by putting the following in your environment:
```
haproxy_allowlistips:
  - 1.1.1.1
  - 2.2.2.2
```

You can also do this on a running loadbalancer by using entering this command:
```
echo "add acl /etc/haproxy/acls/allowedips.acl 1.1.1.1" | socat unix-connect:/var/lib/haproxy/haproxy.stats stdio
echo "add acl /etc/haproxy/acls/allowedips.acl 2.2.2.2" | socat unix-connect:/var/lib/haproxy/haproxy.stats stdio
```
Please note that such a change does not survive a restart of haproxy. Adding them to the acl and deploying haproxy makes it permanent. 

Removing an ip address is done using the command del acl:
```
echo "del acl /etc/haproxy/acls/allowedips.acl 1.1.1.1" | socat unix-connect:/var/lib/haproxy/haproxy.stats stdio
echo "del acl /etc/haproxy/acls/allowedips.acl 2.2.2.2" | socat unix-connect:/var/lib/haproxy/haproxy.stats stdio
```
If you want to view the current list, you can enter:
```
echo "show acl /etc/haproxy/acls/allowedips.acl" | socat unix-connect:/var/lib/haproxy/haproxy.stats stdio
```

## Blocking IP addresses
A blocklist ACL is present to block IP addresses. This can be usefull to quickly block abusers.
If you want to block IP addresses (either in cidr notation, or single ip addresses), you can add them to your configuration under ```haproxy_blocklistips```. Suppose you want to put the ip address 1.1.1.1 and the ip addres 2.2.2.2 to the blocklist, you can do so by putting the following in your environment:

```
haproxy_blocklistips:
  - 1.1.1.1
  - 2.2.2.2
```

You can also do this on a running loadbalancer by using entering this command:
```
echo "add acl /etc/haproxy/acls/blockedips.acl 1.1.1.1" | socat unix-connect:/var/lib/haproxy/haproxy.stats stdio
echo "add acl /etc/haproxy/acls/blockedips.acl 2.2.2.2" | socat unix-connect:/var/lib/haproxy/haproxy.stats stdio
```
Please note that such a change does not survive a restart of haproxy. Adding them to the acl and deploying haproxy makes it permanent. 
Removing an ip address is done using the command del acl:
```
echo "del acl /etc/haproxy/acls/blockedips.acl 1.1.1.1" | socat unix-connect:/var/lib/haproxy/haproxy.stats stdio
echo "del acl /etc/haproxy/acls/blockedips.acl 2.2.2.2" | socat unix-connect:/var/lib/haproxy/haproxy.stats stdio
```

If you want to view the current list, you can enter:
```
echo "show acl /etc/haproxy/acls/blockedips.acl" | socat unix-connect:/var/lib/haproxy/haproxy.stats stdio
```















