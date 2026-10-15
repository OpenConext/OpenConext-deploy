This role cerates database users, we need the following input:

databases.users  # list of dictionaries

for example

databases:
  users:
    - { name: <USERNAME>, db_name: <DBNAME>, password: "<PASSWORD>", privilege: <PRIV> }

database_clients # list