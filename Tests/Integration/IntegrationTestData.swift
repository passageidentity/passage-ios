import AuthenticationServices
@testable import Passage

let apiUrl = "https://auth-uat.passage.dev"

let authToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6Ik1jQWNwMzFhb3dwS0xOb0Y4M2ZwQTVkMSIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJodHRwczovL3RyeS11YXQucGFzc2FnZS5kZXYiLCJleHAiOjE2OTI1NDQ4NjQsImlhdCI6MTY5MjExMjg2NCwiaXNzIjoiaHR0cHM6Ly9hdXRoLXVhdC5wYXNzYWdlLmRldi92MS9hcHBzL2psU2czVnI0TXlLaTFkY2wzb3RWejl4YSIsIm5iZiI6MTY5MjExMjg1OSwic3ViIjoic2pIUXY2OE81Z25TMmlwajBSYjRJa0t5In0.EMcevxcLTPo_JK1bs9ULs8Ng-bOOWJrRqnCRo7KG1-Y57EeR1p6X-c3B0Puii9LC9oCGMUrwZIhlZdkRsJEeklz4b9LmiBn81JXtX7dLHJKduJ08aezJMOdKHVXQ1EixhIMfZxGjthMKm3sXH6uIcrLtlQiJkNtMamaRBVI0X4Lf9Wkgo78_khqgEBlerUkul1Wlo4bFWbGQerUtQa_C8EREX8LBI6ozFE4YxV0nArO2Wbv0D-pLlPN6Lk6DLkVQKPd_x8DgKVBEM9rkX3MOXXrVK6vNvGYf6CZW-4xzz-DAfq1fTqdOG0pJd8vzXHSbUgkttfHgE1NckxUXZ-l1gw"//ProcessInfo.processInfo.environment["PASSAGE_AUTH_TOKEN"]!
let mailosaurAPIKey = "udoOEVY0FNE11tTh"//ProcessInfo.processInfo.environment["MAILOSAUR_API_KEY"]!

let unregisteredUserEmail = "unregistered-test-user@passage.id"
let registeredUserEmail = "ricky.padilla+user01@passage.id"
let magicLinkAppId = "czLTOVFIytGqrhRVoHV9o8Wo"
let magicLinkRegisteredUserEmail = "blayne.bayer@passage.id"

let currentUser = PassageUserInfo(
    createdAt: "2023-07-17T17:45:41.807075Z",
    email: "ricky.padilla+user01@passage.id",
    emailVerified: true,
    id: "sjHQv68O5gnS2ipj0Rb4IkKy",
    lastLoginAt: "",
    loginCount: 2,
    phone: "",
    phoneVerified: false,
    status: "active",
    updatedAt: "",
    webauthn: true,
    webauthnDevices: [],
    webauthnTypes: [],
    codableUserMetadata: nil
)

let appInfoValid = AppInfo(
    allowedIdentifier: "both",
    authFallbackMethodString: "otp",
    authOrigin: "https://try-uat.passage.dev",
    id: "jlSg3Vr4MyKi1dcl3otVz9xa",
    loginURL: "/",
    name: "iOS Integration Test App",
    publicSignup: true,
    redirectURL: "/",
    requiredIdentifier: "both",
    requireEmailVerification: false,
    requireIdentifierVerification: false,
    sessionTimeoutLength: 0,
    userMetadataSchema: []
)

let appInfoInvalid = AppInfo(
    allowedIdentifier: "TEST_ALLOWED_IDENTIFIER",
    authFallbackMethodString: "magic_link",
    authOrigin: "TEST_AUTH_ORIGIN",
    id: "TEST_APP_ID",
    loginURL: "TEST_LOGIN_URL",
    name: "TEST_APP",
    publicSignup: true,
    redirectURL: "TEST_APP_URL",
    requiredIdentifier: "TEST_REQUIRED_IDENTIFIER",
    requireEmailVerification: false,
    requireIdentifierVerification: false,
    sessionTimeoutLength: 6000,
    userMetadataSchema: nil
)

let appInfoRefreshToken = AppInfo(
    allowedIdentifier: "both",
    authFallbackMethodString: "magic_link",
    authOrigin: "http://localhost:4173",
    id: "uFZlFit7nglPuzcYRVesCUBZ",
    loginURL: "/",
    name: "passage-ios uat refresh tokens",
    publicSignup: true,
    redirectURL: "/dashboard",
    requiredIdentifier: "both",
    requireEmailVerification: false,
    requireIdentifierVerification: false,
    sessionTimeoutLength: 5,
    userMetadataSchema: nil
)

let appInfoTest = AppInfo(
    allowedIdentifier: "TEST_ALLOWED_IDENTIFIER",
    authFallbackMethodString: "magic_link",
    authOrigin: "TEST_AUTH_ORIGIN",
    id: "TEST_APP_ID",
    loginURL: "TEST_LOGIN_URL",
    name: "TEST_APP",
    publicSignup: true,
    redirectURL: "TEST_APP_URL",
    requiredIdentifier: "TEST_REQUIRED_IDENTIFIER",
    requireEmailVerification: false,
    requireIdentifierVerification: false,
    sessionTimeoutLength: 6000,
    userMetadataSchema: nil
)

let otpAppInfoValid = AppInfo(
    allowedIdentifier: "both",
    authFallbackMethodString: "otp",
    authOrigin: "http://localhost:4173",
    id: "pTBeTnbvm1z3U6hznMTD33Es",
    loginURL: "/",
    name: "UAT OTP App",
    publicSignup: true,
    redirectURL: "/dashboard",
    requiredIdentifier: "both",
    requireEmailVerification: false,
    requireIdentifierVerification: false,
    sessionTimeoutLength: 6000,
    userMetadataSchema: nil
)

let otpRegisteredUser = PassageUserInfo(
    createdAt: "",
    email:"authentigator+1681334202.318723@passage.id",
    emailVerified: true,
    id: "oiySQzEcqEpzxX3yu5cKKRKe",
    lastLoginAt: "",
    loginCount: 1,
    phone: "",
    phoneVerified: false,
    status: "active",
    updatedAt: "",
    webauthn: false,
    webauthnDevices: [],
    webauthnTypes: [],
    codableUserMetadata: nil
)
