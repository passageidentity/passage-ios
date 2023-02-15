//
//  File.swift
//  
//
//  Created by blayne bayer on 2/14/23.
//

import AuthenticationServices
@testable import Passage

let unregisteredUserEmail = "unregistered-test-user@passage.id"
let registeredUserEmail = "blayne.bayer+integrationtest@passge.id"

let registeredUser = PassageUser(
    id: "dvr55TCBl3eNI5IuGPoYVIrl",
    status: "active",
    email:"blayne.bayer+integrationtest@passge.id",
    email_verified: false,
    phone: "",
    phone_verified: false,
    webauthn: false,
    user_metadata: nil,
    webauthn_types: []
)

let appInfoValid = AppInfo(
    id: "6svMVa1OQTePB7y2rhGRflJ8",
    ephemeral: false,
    name: "authorizer",
    redirect_url: "/dashboard",
    login_url: "/",
    allowed_identifier: "email",
    required_identifier: "email",
    auth_origin: "http://localhost:8080",
    require_email_verification: false,
    require_identifier_verification: false,
    session_timeout_length: 0,
    public_signup: true
)

let appInfoInvalid = AppInfo(
    id: "TEST_APP_ID",
    ephemeral: true,
    name: "TEST_APP",
    redirect_url: "TEST_APP_URL",
    login_url: "TEST_LOGIN_URL",
    allowed_identifier: "TEST_ALLOWED_IDENTIFIER",
    required_identifier: "TEST_REQUIRED_IDENTIFIER",
    auth_origin: "TEST_AUTH_ORIGIN",
    require_email_verification: false,
    require_identifier_verification: false,
    session_timeout_length: 6000,
    public_signup: true
)




let appInfoTest = AppInfo(
    id: "TEST_APP_ID",
    ephemeral: true,
    name: "TEST_APP",
    redirect_url: "TEST_APP_URL",
    login_url: "TEST_LOGIN_URL",
    allowed_identifier: "TEST_ALLOWED_IDENTIFIER",
    required_identifier: "TEST_REQUIRED_IDENTIFIER",
    auth_origin: "TEST_AUTH_ORIGIN",
    require_email_verification: false,
    require_identifier_verification: false,
    session_timeout_length: 6000,
    public_signup: true
)
