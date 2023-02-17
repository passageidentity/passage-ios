//
//  File.swift
//  
//
//  Created by blayne bayer on 2/14/23.
//

import AuthenticationServices
@testable import Passage

let apiUrl = "https://auth-uat.passage.dev"

let authToken = ProcessInfo.processInfo.environment["PASSAGE_AUTH_TOKEN"]!
let mailosaurAPIKey = ProcessInfo.processInfo.environment["MAILOSAUR_API_KEY"]!

let unregisteredUserEmail = "unregistered-test-user@passage.id"
let registeredUserEmail = "blayne.bayer+integrationtest@passge.id"

let registeredUser = PassageUser(
    id: "BMQ9Jbi90ubPvX9H1XU5oyfR",
    status: "active",
    email:"blayne.bayer@passage.id",
    email_verified: true,
    phone: "",
    phone_verified: false,
    webauthn: true,
    user_metadata: nil,
    webauthn_types: []
)

let currentUser = PassageUserDetails(
    created_at: "2023-02-16T15:55:28.890571Z",
    updated_at: "2023-02-16T19:55:38.909048Z",
    status: "active",
    id: "BMQ9Jbi90ubPvX9H1XU5oyfR",
    email: "blayne.bayer@passage.id",
    email_verified: true,
    phone: "",
    phone_verified: false,
    webauthn: true,
    last_login_at: "2023-02-16T19:55:38.907657Z",
    login_count: 2,
    webauthn_devices: [],
    webauthn_types: []
)


let appInfoValid = AppInfo(
    id: "czLTOVFIytGqrhRVoHV9o8Wo",
    ephemeral: false,
    name: "passage-ios uat",
    redirect_url: "/dashboard",
    login_url: "/",
    allowed_identifier: "both",
    required_identifier: "both",
    auth_origin: "http://localhost:4173",
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
