CREATE TABLE  IF NOT EXISTS  `log_logins` (
  `loginstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `userid` varchar(1000) NOT NULL,
  `spentityid` varchar(1000) DEFAULT NULL,
  `idpentityid` varchar(1000) DEFAULT NULL,
  `trustedproxyentityid` varchar(1000) DEFAULT NULL,
  `keyid` varchar(50) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sessionid` varchar(50) DEFAULT NULL,
  `requestid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_index` (`sessionid`,`requestid`),
  KEY `loginstamp_index` (`loginstamp`),
  KEY `idpentityid_index` (`idpentityid`(255)),
  KEY `spentityid_index` (`spentityid`(255)),
  KEY `keyid_index` (`keyid`,`loginstamp`,`spentityid`(255)),
  KEY `userid_idp_index` (`userid`(128),`idpentityid`(64))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
