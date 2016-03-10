#!/bin/bash
PATH="/bin:/sbin:/usr/sbin"

# Define Some Variables:
#=======================

# Initialization:
#================
iptables -F
iptables -X
iptables -Z
echo {{ ip_forward }} > /proc/sys/net/ipv4/ip_forward
echo "1" > /proc/sys/net/ipv4/ip_dynaddr

iptables -t raw -A PREROUTING -j NOTRACK
iptables -t raw -A OUTPUT -j NOTRACK

# Set default policy to drop:
#============================
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Allow all connections on loopback interface:
#=============================================
iptables -A INPUT  -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow Incoming/outgoing Pings:
#===============================
# Incoming:
#----------
iptables -A INPUT  -p icmp --icmp-type echo-request -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT
# Outgoing:
#----------
iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT  -p icmp --icmp-type echo-reply -j ACCEPT

# Outgoing Connections:
#======================

# DNS resolving:
#===============
iptables -A INPUT  -p udp --sport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

{% for service in outgoing %}
{{'##'|e }} {{ service.name }}
{{'##'|e }} {{'=' * service.name|length }}
iptables -A OUTPUT  -p {{ service.protocol | default('tcp') }} {{ '-d '+service.destination if service.destination is defined else '' }} --dport {{ service.port }}  -j ACCEPT
iptables -A INPUT   -p {{ service.protocol | default('tcp') }} {{ '-s '+service.destination if service.destination is defined else '' }} --sport {{ service.port }}  {{ '' if service.protocol is defined and service.protocol == 'udp' else '! --syn ' }} -j ACCEPT
{% endfor %}

# Incoming Connections:
#======================

{% for service in incoming %}
{{'##'|e }} {{ service.name }}
{{'##'|e }} {{'=' * service.name|length }}
iptables -A INPUT  -p {{ service.protocol | default('tcp') }} {{ '-s '+service.source if service.source is defined else '' }} --dport {{ service.port }}  -j ACCEPT
iptables -A OUTPUT -p {{ service.protocol | default('tcp') }} {{ '-d '+service.source if service.source is defined else '' }} --sport {{ service.port }}  {{ '' if service.protocol is defined and service.protocol == 'udp' else '! --syn ' }} -j ACCEPT
{% endfor %}

# Save active ruleset:
#=====================
/etc/init.d/iptables save active
