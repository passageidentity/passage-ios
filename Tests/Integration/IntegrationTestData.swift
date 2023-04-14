import AuthenticationServices
@testable import Passage

let apiUrl = "https://auth-uat.passage.dev"

let authToken = ProcessInfo.processInfo.environment["PASSAGE_AUTH_TOKEN"]!
let mailosaurAPIKey = ProcessInfo.processInfo.environment["MAILOSAUR_API_KEY"]!

let unregisteredUserEmail = "unregistered-test-user@passage.id"
let registeredUserEmail = "blayne.bayer+integrationtest@passge.id"

let registeredUser = PassageUserInfo(
    createdAt: "",
    email:"blayne.bayer@passage.id",
    emailVerified: true,
    id: "BMQ9Jbi90ubPvX9H1XU5oyfR",
    lastLoginAt: "",
    loginCount: 1,
    phone: "",
    phoneVerified: false,
    status: "active",
    updatedAt: "",
    webauthn: true,
    webauthnDevices: [],
    webauthnTypes: []
)

let currentUser = PassageUserInfo(
    createdAt: "2023-02-16T15:55:28.890571Z",
    email: "blayne.bayer@passage.id",
    emailVerified: true,
    id: "BMQ9Jbi90ubPvX9H1XU5oyfR",
    lastLoginAt: "2023-02-16T19:55:38.907657Z",
    loginCount: 2,
    phone: "",
    phoneVerified: false,
    status: "active",
    updatedAt: "2023-02-16T19:55:38.909048Z",
    webauthn: true,
    webauthnDevices: [],
    webauthnTypes: []
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

let otpAppInfoValid = AppInfo(
    allowedIdentifier: "both",
    authFallbackMethodString: "otp",
    authOrigin: "http://localhost:4173",
    ephemeral: false,
    id: "pTBeTnbvm1z3U6hznMTD33Es",
    loginURL: "/",
    name: "UAT OTP App",
    publicSignup: true,
    redirectURL: "/dashboard",
    requiredIdentifier: "both",
    requireEmailVerification: false,
    requireIdentifierVerification: false,
    sessionTimeoutLength: 6000
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
    webauthnTypes: []
)
