import AuthenticationServices
@testable import Passage

let unregisteredUserEmail = "unregistered-test-user@passage.id"
let registeredUserEmail = "registered-test-user@passage.id"

let testAppInfo = AppInfo(
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

let testRegisterStartResponse = WebauthnRegisterStartResponse(
    user: PassageUser(id: "TEST_ID", email_verified: true, phone_verified: true, webauthn: true),
    handshake: WebauthnRegisterStartResponseHandshake(
        id: "TEST_ID",
        challenge: WebauthnRegisterStartResponseHandshakeChallenge(
            publicKey: WebauthnRegisterStartResponseHandshakeChallengePublicKey(
                attestation: "TEST_ATTESTATION",
                pubKeyCredParams: [],
                rp: WebauthnRegisterStartResponseHandshakeChallengePublicKeyRelyingParty(
                    name: "TEST_NAME",
                    id: "TEST_ID"
                ),
                user: WebauthnRegisterStartResponseHandshakeChallengePublicKeyUser(
                    displayName: "TEST_DISPLAY_NAME",
                    id: "TEST_ID",
                    name: "TEST_NAME"
                ),
                challenge: "TEST_CHALLENGE",
                authenticatorSelection: WebauthnRegisterStartResponseHandshakeChallengePublicKeyAuthenticatorSelection(
                    authenticatorAttachment: "TEST_AUTH_ATT"
                ),
                timeout: 6000
            )
        )
    )
)
