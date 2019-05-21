 CREATE TABLE IF NOT EXISTS `last_login` (
  `userid` varchar(255) NOT NULL,
  `lastseen` date DEFAULT NULL,
  PRIMARY KEY (`userid`),
  UNIQUE KEY `idx_user` (`userid`),
  KEY `idx_lastseen` (`lastseen`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
