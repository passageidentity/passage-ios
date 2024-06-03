/// A respsonse struct for the app info request, contains a root object of type ``AppInfo``
internal struct AppInfoResponse: Codable {
    /// Root element of the response of type ``AppInfo``
    public let app: AppInfo
}

internal struct WebauthnLoginStartResponseHandshakeChallengePublicKeyCredential: Codable {
    public let id: String
    public let transports: [String]?
    public let type: String
}

/// Details of the Public Key
internal struct WebauthnLoginStartResponseHandshakeChallengePublicKey: Codable {
    /// The challenge to use for the Credential Assertion
    public let challenge: String
    /// The timeout
    public let timeout: Int
    public let rpId: String
    public let allowCredentials: [WebauthnLoginStartResponseHandshakeChallengePublicKeyCredential]?
}

/// Contains the Public Key to use for the credential assertion
internal struct WebauthnLoginStartResponseHandshakeChallenge: Codable {
    /// ``WebauthnLoginStartResponseHandshakeChallengePublicKey``
    public let publicKey: WebauthnLoginStartResponseHandshakeChallengePublicKey
}

/// Represents a handshake
internal struct WebauthnLoginStartResponseHandshake: Codable {
    /// The id of the handshake
    public let id: String
    /// ``WebauthnLoginStartResponseHandshakeChallenge``
    public let challenge: WebauthnLoginStartResponseHandshakeChallenge
}

/// API Response from a webauthn login start request
internal struct WebauthnLoginStartResponse: Codable {
    /// ``WebauthnLoginStartResponseHandshake``
    public let handshake: WebauthnLoginStartResponseHandshake
    /// ``PassageUserInfo`` will only be defined when logging with an identifier
    public let user: PassageUserInfo?
}

internal struct AuthResultResponse: Codable {
    /// ``AuthResult``
    public let authResult: AuthResult
    internal enum CodingKeys: String, CodingKey {
        case authResult = "auth_result"
    }
}

/// API Response from a webauthn login finish request
internal typealias WebauthnLoginFinishResponse = AuthResultResponse

internal struct WebauthnRegisterStartResponseHandshakeChallengePublicKeyPubKeyCredParam: Codable {
    public let alg: Int
    public let type: String
}

internal struct WebauthnRegisterStartResponseHandshakeChallengePublicKeyRelyingParty: Codable {
    public let name: String
    public let id: String
}

internal struct WebauthnRegisterStartResponseHandshakeChallengePublicKeyUser: Codable {
    public let displayName: String
    public let id: String
    public let name: String
}

internal struct WebauthnRegisterStartResponseHandshakeChallengePublicKeyAuthenticatorSelection: Codable {
    public let authenticatorAttachment: String?
}

internal struct WebauthnRegisterStartResponseHandshakeChallengePublicKey: Codable {
    public let attestation: String
    public let pubKeyCredParams: [WebauthnRegisterStartResponseHandshakeChallengePublicKeyPubKeyCredParam]
    public let rp: WebauthnRegisterStartResponseHandshakeChallengePublicKeyRelyingParty
    public let user: WebauthnRegisterStartResponseHandshakeChallengePublicKeyUser
    public let challenge: String
    public let authenticatorSelection: WebauthnRegisterStartResponseHandshakeChallengePublicKeyAuthenticatorSelection
    public let timeout: Int
}

internal struct WebauthnRegisterStartResponseHandshakeChallenge: Codable {
    public let publicKey: WebauthnRegisterStartResponseHandshakeChallengePublicKey
}

internal struct WebauthnRegisterStartResponseHandshake: Codable {
    public let id: String
    public let challenge: WebauthnRegisterStartResponseHandshakeChallenge
}

/// API Response from a webauthn registration start request
internal struct WebauthnRegisterStartResponse: Codable {
    public let user: PassageUserInfo
    public let handshake: WebauthnRegisterStartResponseHandshake
}

/// API Response from webauthn registration finish
internal typealias WebauthnRegisterFinishResponse = AuthResultResponse

internal typealias WebauthnAddDeviceFinishResponse = UpdateDeviceResponse

internal typealias SendMagicLinkResponse = MagicLinkResponse

internal typealias MagicLinkStatusResponse = AuthResultResponse

internal typealias ActivateMagicLinkResponse = AuthResultResponse

internal typealias ActivateOneTimePasscodeResponse = AuthResultResponse

internal struct ListDevicesResponse: Codable {
    public let devices: [DeviceInfo]
}

internal typealias ChangeEmailResponse = MagicLinkResponse

internal typealias ChangePhoneResponse = MagicLinkResponse

internal struct UpdateDeviceResponse: Codable {
    public let device: DeviceInfo
}

internal struct GetUserResponse: Codable {
    public let user: PassageUserInfo
}

internal typealias RefreshResponse = AuthResultResponse
