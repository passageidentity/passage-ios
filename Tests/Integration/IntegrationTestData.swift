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
    allowedIdentifier: "both",
    authFallbackMethodString: "magic_link",
    authOrigin: "http://localhost:4173",
    ephemeral: false,
    id: "czLTOVFIytGqrhRVoHV9o8Wo",
    loginURL: "/",
    name: "passage-ios uat",
    publicSignup: true,
    redirectURL: "/dashboard",
    requiredIdentifier: "both",
    requireEmailVerification: false,
    requireIdentifierVerification: false,
    sessionTimeoutLength: 0
)

let appInfoInvalid = AppInfo(
    allowedIdentifier: "TEST_ALLOWED_IDENTIFIER",
    authFallbackMethodString: "magic_link",
    authOrigin: "TEST_AUTH_ORIGIN",
    ephemeral: true,
    id: "TEST_APP_ID",
    loginURL: "TEST_LOGIN_URL",
    name: "TEST_APP",
    publicSignup: true,
    redirectURL: "TEST_APP_URL",
    requiredIdentifier: "TEST_REQUIRED_IDENTIFIER",
    requireEmailVerification: false,
    requireIdentifierVerification: false,
    sessionTimeoutLength: 6000
)

let appInfoRefreshToken = AppInfo(
    allowedIdentifier: "both",
    authFallbackMethodString: "magic_link",
    authOrigin: "http://localhost:4173",
    ephemeral: false,
    id: "uFZlFit7nglPuzcYRVesCUBZ",
    loginURL: "/",
    name: "passage-ios uat refresh tokens",
    publicSignup: true,
    redirectURL: "/dashboard",
    requiredIdentifier: "both",
    requireEmailVerification: false,
    requireIdentifierVerification: false,
    sessionTimeoutLength: 5
)

let appInfoTest = AppInfo(
    allowedIdentifier: "TEST_ALLOWED_IDENTIFIER",
    authFallbackMethodString: "magic_link",
    authOrigin: "TEST_AUTH_ORIGIN",
    ephemeral: true,
    id: "TEST_APP_ID",
    loginURL: "TEST_LOGIN_URL",
    name: "TEST_APP",
    publicSignup: true,
    redirectURL: "TEST_APP_URL",
    requiredIdentifier: "TEST_REQUIRED_IDENTIFIER",
    requireEmailVerification: false,
    requireIdentifierVerification: false,
    sessionTimeoutLength: 6000
)
