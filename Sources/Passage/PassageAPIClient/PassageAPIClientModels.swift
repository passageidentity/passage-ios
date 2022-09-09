//
//  PassageAPIClientModels.swift
//  Shiny
//
//  Created by blayne bayer on 8/23/22.
//  Copyright © 2022 Apple. All rights reserved.
//

/// A respsonse struct for the app info request, contains a root object of type ``AppInfo``
internal struct AppInfoResponse : Codable {
    
    /// Root element of the response of type ``AppInfo``
    public var app: AppInfo
}


/// Details of the Public Key
internal struct WebauthnLoginStartResponseHandshakeChallengePublicKey : Codable {
    
    /// The challenge to use for the Credential Assertion
    public var challenge: String
    
    /// The timeout
    public var timeout: Int
    
    public var rpId: String
}

/// Contains the Public Key to use for the credential assertion
internal struct WebauthnLoginStartResponseHandshakeChallenge : Codable {
    
    /// ``WebauthnLoginStartResponseHandshakeChallengePublicKey``
    public var publicKey: WebauthnLoginStartResponseHandshakeChallengePublicKey
}

/// Represents a handshake
internal struct WebauthnLoginStartResponseHandshake : Codable {
    
    /// The id of the handshake
    public var id: String
        
    /// ``WebauthnLoginStartResponseHandshakeChallenge``
    public var challenge: WebauthnLoginStartResponseHandshakeChallenge
}

/// API Response from a webauthn login start request
internal struct WebauthnLoginStartResponse : Codable {
    
    /// ``WebauthnLoginStartResponseHandshake``
    public var handshake: WebauthnLoginStartResponseHandshake
    
    /// ``PassageUser`` will only be defined when logging with an identifier
    public var user: PassageUser?
}

/// API Response from a webauthn login finish request
internal struct WebauthnLoginFinishResponse : Codable {
    
    /// ``AuthResult``
    public var auth_result: AuthResult
}

internal struct WebauthnRegisterStartResponseHandshakeChallengePublicKeyPubKeyCredParam : Codable {
    public var alg: Int
    public var type: String
}

internal struct WebauthnRegisterStartResponseHandshakeChallengePublicKeyRelyingParty : Codable {
    public var name: String
    public var id: String
}

internal struct WebauthnRegisterStartResponseHandshakeChallengePublicKeyUser : Codable {
    public var displayName: String
    public var id: String
    public var name: String
}

internal struct WebauthnRegisterStartResponseHandshakeChallengePublicKeyAuthenticatorSelection : Codable {
    public var authenticatorAttachment: String
}

internal struct WebauthnRegisterStartResponseHandshakeChallengePublicKey : Codable {
    public var attestation: String
    public var pubKeyCredParams: [WebauthnRegisterStartResponseHandshakeChallengePublicKeyPubKeyCredParam]
    public var rp: WebauthnRegisterStartResponseHandshakeChallengePublicKeyRelyingParty
    public var user: WebauthnRegisterStartResponseHandshakeChallengePublicKeyUser
    public var challenge: String
    public var authenticatorSelection: WebauthnRegisterStartResponseHandshakeChallengePublicKeyAuthenticatorSelection
    public var timeout: Int
}

internal struct WebauthnRegisterStartResponseHandshakeChallenge : Codable {
    public var publicKey: WebauthnRegisterStartResponseHandshakeChallengePublicKey
}

internal struct WebauthnRegisterStartResponseHandshake : Codable {
    public var id: String
    public var challenge: WebauthnRegisterStartResponseHandshakeChallenge
}

/// API Response from a webauthn registration start request
internal struct WebauthnRegisterStartResponse : Codable {
    public var user: PassageUser
    public var handshake: WebauthnRegisterStartResponseHandshake
}

/// API Response from webauthn registration finish
internal struct WebauthnRegisterFinishResponse : Codable {
    
    /// ``AuthResult``
    public var auth_result: AuthResult
}

internal struct WebauthnAddDeviceFinishResponse : Codable {
    /// ``AuthResult``
    public var auth_result: AuthResult
}

internal struct SendMagicLinkResponse : Codable {
    public var magic_link: MagicLink
}

internal struct MagicLinkStatusResponse : Codable {
    public var auth_result: AuthResult
}

internal struct ActivateMagicLinkResponse : Codable {
    public var auth_result: AuthResult
}


internal struct CurrentUserResponse : Codable {
    public var user: PassageUserDetails
}


internal struct ListDevicesResponse : Codable {
    public var devices: [DeviceInfo]
}

internal struct ChangeEmailResponse : Codable {
    public var magic_link: MagicLink
}

internal struct ChangePhoneResponse : Codable {
    public var magic_link: MagicLink
}

internal struct UpdateDeviceResponse : Codable {
    public var device: DeviceInfo
}

internal struct GetUserResponse : Codable {
    public var user: PassageUser
}


