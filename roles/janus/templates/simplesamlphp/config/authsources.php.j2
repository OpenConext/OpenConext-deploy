<?php

$presetIdp = NULL;
$metadata = array();

// If there is only one IdP (Like only this environments EngineBlock)
require_once __DIR__ . "/../metadata/saml20-idp-remote.php";
if (!empty($metadata) && count($metadata) === 1) {
    $metadataIdps = array_keys($metadata);
    $presetIdp = array_shift($metadataIdps);
}

$config = array(

    // This is a authentication source which handles admin authentication.
    'login-admin' => array(
        // The default is to use core:AdminPassword, but it can be replaced with
        // any authentication source.

        'core:AdminPassword',
    ),


    // An authentication source which can authenticate against both SAML 2.0
    // and Shibboleth 1.3 IdPs.
    'default-sp' => array(
        'saml:SP',

        // The entity ID of this SP.
        // Can be NULL/unset, in which case an entity ID is generated based on the metadata URL.
        'entityID' => NULL,

        // The entity ID of the IdP this should SP should contact.
        // Can be NULL/unset, in which case the user will be shown a list of available IdPs.
        'idp' => $presetIdp,

        // The URL to the discovery service.
        // Can be NULL/unset, in which case a builtin discovery service will be used.
        'discoURL' => NULL,

        'authproc' => array(
            20 => array(
                   'class' => 'saml:NameIDAttribute',
                   'format' => '%V',
                    'attribute' => 'NameID',
            ),
        ),
    ),
);
