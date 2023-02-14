//
//  File.swift
//  
//
//  Created by blayne bayer on 2/14/23.
//

import AuthenticationServices
@testable import Passage

let unregisteredUserEmail = "unregistered-test-user@passage.id"


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
