USE `oidc-server`;

CREATE TABLE IF NOT EXISTS client_contact (
  owner_id BIGINT,
  contact VARCHAR(256)
);
REPLACE INTO `client_contact` VALUES (1,'j.doe@example.com');

CREATE TABLE IF NOT EXISTS client_details (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,

  client_description VARCHAR(1024),
  reuse_refresh_tokens BOOLEAN DEFAULT true NOT NULL,
  dynamically_registered BOOLEAN DEFAULT false NOT NULL,
  allow_introspection BOOLEAN DEFAULT false NOT NULL,
  id_token_validity_seconds BIGINT DEFAULT 600 NOT NULL,

  client_id VARCHAR(256),
  client_secret VARCHAR(2048),
  access_token_validity_seconds BIGINT,
  refresh_token_validity_seconds BIGINT,

  application_type VARCHAR(256),
  client_name VARCHAR(256),
  token_endpoint_auth_method VARCHAR(256),
  subject_type VARCHAR(256),

  logo_uri VARCHAR(2048),
  policy_uri VARCHAR(2048),
  client_uri VARCHAR(2048),
  tos_uri VARCHAR(2048),

  jwks_uri VARCHAR(2048),
  jwks VARCHAR(8192),
  sector_identifier_uri VARCHAR(2048),

  request_object_signing_alg VARCHAR(256),

  user_info_signed_response_alg VARCHAR(256),
  user_info_encrypted_response_alg VARCHAR(256),
  user_info_encrypted_response_enc VARCHAR(256),

  id_token_signed_response_alg VARCHAR(256),
  id_token_encrypted_response_alg VARCHAR(256),
  id_token_encrypted_response_enc VARCHAR(256),

  token_endpoint_auth_signing_alg VARCHAR(256),

  default_max_age BIGINT,
  require_auth_time BOOLEAN,
  created_at TIMESTAMP NULL,
  initiate_login_uri VARCHAR(2048),
  clear_access_tokens_on_refresh BOOLEAN DEFAULT true NOT NULL,

  UNIQUE (client_id)
);
REPLACE INTO `client_details` VALUES (1,NULL,1,0,1,600,'http@//mock-sp','secret',3600,NULL,NULL,'Default client','SECRET_BASIC','PUBLIC',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,60000,1,'2016-03-15 12:15:24',NULL,1);

CREATE TABLE IF NOT EXISTS client_grant_type (
  owner_id BIGINT,
  grant_type VARCHAR(2000)
);
REPLACE INTO `client_grant_type` VALUES (1,'client_credentials'),(1,'implicit'),(1,'authorization_code');

CREATE TABLE IF NOT EXISTS client_response_type (
  owner_id BIGINT,
  response_type VARCHAR(2000)
);
REPLACE INTO `client_response_type` VALUES (1,'token'),(1,'code');

CREATE TABLE IF NOT EXISTS client_scope (
  owner_id BIGINT,
  scope VARCHAR(2048)
);
REPLACE INTO `client_scope` VALUES (1,'phone'),(1,'organization'),(1,'email'),(1,'address'),(1,'openid'),(1,'userids'),(1,'entitlement'),(1,'profile'),(1,'members'),(1,'groups');

