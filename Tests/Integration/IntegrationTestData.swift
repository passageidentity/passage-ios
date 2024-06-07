import AuthenticationServices
@testable import Passage

let apiUrl = "https://auth-uat.passage.dev/v1"

let authToken = ProcessInfo.processInfo.environment["PASSAGE_AUTH_TOKEN"]!
let mailosaurAPIKey = ProcessInfo.processInfo.environment["MAILOSAUR_API_KEY"]!

let checkEmailWaitTime = UInt64(4 * Double(NSEC_PER_SEC))// nanoseconds
let checkEmailTryCount = 6

let unregisteredUserEmail = "unregistered-test-user@passage.id"
let registeredUserEmail = "ricky.padilla+user01@passage.id"

let magicLinkAppId = "czLTOVFIytGqrhRVoHV9o8Wo"
let magicLinkRegisteredUserEmail = "blayne.bayer@passage.id"
let magicLinkUnactivatedId = "ioM1TTG0eiWMrOq9FA7X5zMN"

let otpAppId = "pTBeTnbvm1z3U6hznMTD33Es"

let refreshTestAppId = "uFZlFit7nglPuzcYRVesCUBZ"
let refreshTestSessionTimeout = 5

let existingDeviceId = "c70NVyTQGj7EXjTagAmkK0we"

let currentUser = PassageUserInfo(
    createdAt: "2023-07-17T17:45:41.807075Z",
    email: "ricky.padilla+user01@passage.id",
    emailVerified: true,
    id: "sjHQv68O5gnS2ipj0Rb4IkKy",
    lastLoginAt: "",
    loginCount: 2,
    phone: "",
    phoneVerified: false,
    socialConnections: nil,
    status: "active",
    updatedAt: "",
    userMetadata: nil,
    webauthn: true,
    webauthnDevices: [],
    webauthnTypes: []
)

let appInfoValid = AppInfo(
    allowedIdentifier: "both",
    authFallbackMethod: .otp,
    authFallbackMethodTtl: 0,
    authMethods: AuthMethods(),
    authOrigin: "https://try-uat.passage.dev",
    defaultLanguage: "en",
    elementCustomization: ElementCustomization(),
    elementCustomizationDark: ElementCustomization(),
    ephemeral: false,
    id: "jlSg3Vr4MyKi1dcl3otVz9xa",
    layouts: Layouts(profile: [], registration: []),
    loginUrl: "/",
    name: "iOS Integration Test App",
    passageBranding: true,
    publicSignup: true,
    profileManagement: false,
    redirectUrl: "/",
    requireEmailVerification: false,
    requireIdentifierVerification: false,
    requiredIdentifier: "",
    rsaPublicKey: "",
    sessionTimeoutLength: 1000000,
    socialConnections: SocialConnections(),
    userMetadataSchema: []
)

let appInfoInvalid = AppInfo(
    allowedIdentifier: "TEST_ALLOWED_IDENTIFIER",
    authFallbackMethod: .magicLink,
    authFallbackMethodTtl: 0,
    authMethods: AuthMethods(),
    authOrigin: "TEST_AUTH_ORIGIN",
    defaultLanguage: "TEST_LANG",
    elementCustomization: ElementCustomization(),
    elementCustomizationDark: ElementCustomization(),
    ephemeral: false,
    id: "TEST_APP_ID",
    layouts: Layouts(profile: [], registration: []),
    loginUrl: "TEST_LOGIN_URL",
    name: "TEST_APP",
    passageBranding: true,
    publicSignup: true,
    profileManagement: false,
    redirectUrl: "/",
    requireEmailVerification: false,
    requireIdentifierVerification: false,
    requiredIdentifier: "",
    rsaPublicKey: "",
    sessionTimeoutLength: 1000000,
    socialConnections: SocialConnections(),
    userMetadataSchema: []
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
    socialConnections: nil,
    status: "active",
    updatedAt: "",
    userMetadata: nil,
    webauthn: false,
    webauthnDevices: [],
    webauthnTypes: []
)
