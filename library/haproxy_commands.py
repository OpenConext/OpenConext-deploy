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
    "static_blauwrood_servers": {"static_blauwrood_servers": True, "type": "list"},
    "stepup_blauwrood_servers": {"stepup_blauwrood_servers": True, "type": "list"},
    "stepup_blauwrood_servers_migration": {"stepup_blauwrood_servers_migration": True, "type": "list"},
    "weight": {"type": "str"},
    "color": {"required": True, "type": "str"},
    "app_name": {"required": True, "type": "str"},
    "app_type": {"required": True, "type": "str"},
    "state": {"type": "str"}
  }
  module = AnsibleModule(argument_spec=fields)
  java_servers = [s["label"] for s in module.params["java_blauwrood_servers"]]
  php_servers = [s["label"] for s in module.params["php_blauwrood_servers"]]
  static_servers = [s["label"] for s in module.params["static_blauwrood_servers"]]
  stepup_servers = [s["label"] for s in module.params["stepup_blauwrood_servers"]]
  stepup_servers_migration = [s["label"] for s in module.params["stepup_blauwrood_servers_migration"]]
  app_name = module.params["app_name"].lower()
  app_type = module.params["app_type"].lower()

  weight = module.params["weight"]
  color = module.params["color"]

  state = module.params["state"]

  if app_type == "java":
      servers = java_servers 
  elif app_type == "php":
      servers = php_servers
  elif app_type == "static":
      servers = static_servers
  elif app_type == "stepup":
      servers = stepup_servers
  elif app_type == "stepupmigration":
      servers = stepup_servers_migration

  red_servers = [s for s in servers if s.upper().endswith("ROOD")]
  blue_servers = [s for s in servers if s.upper().endswith("BLAUW")]
  if color == "rood":
      state_servers = red_servers
  elif color == "blauw":
      state_servers = blue_servers
  
  if state:
    haproxy_items = [_haproxy_state(s, state, app_name) for s in state_servers]
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
