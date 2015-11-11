Architecture of the OpenConext platform.
==============================

# Spring boot applications

The following flow is how teams.test.surfoncext.nl is set up. For all the other Spring boot application the same configuration applies:

teams.test.surfconext.nl points to t05.dev.coin.surf.net (e.g. 145.100.191.122)
nginx listens on the loadbalancer node on 80 and 443, ends the ssl and forwards to haproxy on localhost 
haproxy listens per app on a port, each app has multiple nodes configured and haproxy forwards to specified port on the node
on the actual node apache listens - we need apache because of shibboleth - and forwards to localhost: spring port
