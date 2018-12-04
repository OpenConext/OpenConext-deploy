#!/bin/env python
from ansible.module_utils.basic import *


def _haproxy_weight(host, weight, app_name):
  return {
    "host": host, "weight": str(weight) + "%", "backend": app_name + "_be",
    "socket": "/var/lib/haproxy/" + app_name + ".stats"
  }


def _haproxy_state(host, state, app_name):
  return {
    "host": host, "state": state, "backend": app_name + "_be",
    "socket": "/var/lib/haproxy/" + app_name + ".stats", "wait": "yes"
  }


if __name__ == "__main__":
  fields = {
    "java_blauwrood_servers": {"java_blauwrood_servers": True, "type": "list"},
    "php_blauwrood_servers": {"php_blauwrood_servers": True, "type": "list"},
    "weight": {"type": "str"},
    "color": {"type": "str"},
    "app_name": {"required": True, "type": "str"},
    "app_type": {"required": True, "type": "str"},
    "state": {"type": "str"}
  }
  module = AnsibleModule(argument_spec=fields)
  java_servers = [s["label"] for s in module.params["java_blauwrood_servers"]]
  php_servers = [s["label"] for s in module.params["php_blauwrood_servers"]]
  app_name = module.params["app_name"].lower()
  app_type = module.params["app_type"].lower()

  weight = module.params["weight"]
  color = module.params["color"]

  state = module.params["state"]

  servers = java_servers if app_type == "java" else php_servers
  red_servers = [s for s in servers if s.upper().endswith("ROOD")]
  blue_servers = [s for s in servers if s.upper().endswith("BLAUW")]

  if state:
    haproxy_items = [_haproxy_state(s, state, app_name) for s in red_servers + blue_servers]
    module.exit_json(haproxy_items=haproxy_items)
  else:
    weight = int(weight[:-1]) if weight.endswith("%") else int(weight)
    other_weight = 100 - weight
    color = color.lower()

    red_weight = weight if color == "rood" else other_weight
    blue_weight = weight if color == "blauw" else other_weight

    red_items = [_haproxy_weight(s, red_weight, app_name) for s in red_servers]
    blue_items = [_haproxy_weight(s, blue_weight, app_name) for s in blue_servers]
    module.exit_json(haproxy_items=red_items + blue_items)
