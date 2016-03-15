USE `oidc-server`;
REPLACE INTO `client_contact` VALUES (1,'j.doe@example.com');
REPLACE INTO `client_details` VALUES (1,NULL,1,0,1,600,'http@//mock-sp','secret',3600,NULL,NULL,'Default client','SECRET_BASIC','PUBLIC',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,60000,1,'2016-03-15 12:15:24',NULL,1);
REPLACE INTO `client_grant_type` VALUES (1,'client_credentials'),(1,'implicit'),(1,'authorization_code');
REPLACE INTO `client_response_type` VALUES (1,'token'),(1,'code');
REPLACE INTO `client_scope` VALUES (1,'phone'),(1,'organization'),(1,'email'),(1,'address'),(1,'openid'),(1,'userids'),(1,'entitlement'),(1,'profile'),(1,'members'),(1,'groups');

