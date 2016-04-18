keepalived:
  state_master: BACKUP 
  state_backup: MASTER
  masterprio: 100
  backupprio: 101
