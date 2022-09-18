import AuthenticationServices
@testable import Passage

let unregisteredUserEmail = "unregistered-test-user@passage.id"
let registeredUserEmail = "registered-test-user@passage.id"

let testAppInfo = AppInfo(
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

let testLoginStartResponse = WebauthnLoginStartResponse(
    handshake: WebauthnLoginStartResponseHandshake(
        id: "TEST_ID",
        challenge: WebauthnLoginStartResponseHandshakeChallenge(
            publicKey: WebauthnLoginStartResponseHandshakeChallengePublicKey(
                challenge: "TEST_CHALLENGE",
                timeout: 6000,
                rpId: "TEST_RPID"
            )
        )
    )
)

let testLoginFinishResponse = AuthResult(
    auth_token: "TEST_TOKEN",
    redirect_url: nil
)
