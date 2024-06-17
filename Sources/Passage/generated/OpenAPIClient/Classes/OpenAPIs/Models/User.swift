//
// User.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct User: Codable, JSONEncodable, Hashable {

    public var email: String
    /** Whether or not the user's email has been verified */
    public var emailVerified: Bool
    public var id: String
    public var phone: String
    /** Whether or not the user's phone has been verified */
    public var phoneVerified: Bool
    public var status: UserStatus
    public var userMetadata: AnyCodable?
    public var webauthn: Bool
    public var webauthnTypes: [WebAuthnType]?

    public init(email: String, emailVerified: Bool, id: String, phone: String, phoneVerified: Bool, status: UserStatus, userMetadata: AnyCodable?, webauthn: Bool, webauthnTypes: [WebAuthnType]) {
        self.email = email
        self.emailVerified = emailVerified
        self.id = id
        self.phone = phone
        self.phoneVerified = phoneVerified
        self.status = status
        self.userMetadata = userMetadata
        self.webauthn = webauthn
        self.webauthnTypes = webauthnTypes
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case email
        case emailVerified = "email_verified"
        case id
        case phone
        case phoneVerified = "phone_verified"
        case status
        case userMetadata = "user_metadata"
        case webauthn
        case webauthnTypes = "webauthn_types"
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(emailVerified, forKey: .emailVerified)
        try container.encode(id, forKey: .id)
        try container.encode(phone, forKey: .phone)
        try container.encode(phoneVerified, forKey: .phoneVerified)
        try container.encode(status, forKey: .status)
        try container.encode(userMetadata, forKey: .userMetadata)
        try container.encode(webauthn, forKey: .webauthn)
        try container.encode(webauthnTypes, forKey: .webauthnTypes)
    }
}
