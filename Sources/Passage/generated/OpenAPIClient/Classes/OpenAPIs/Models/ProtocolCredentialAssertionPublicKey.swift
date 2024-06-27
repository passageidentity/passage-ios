//
// ProtocolCredentialAssertionPublicKey.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct ProtocolCredentialAssertionPublicKey: Codable, JSONEncodable, Hashable {

    public var allowCredentials: [ProtocolCredentialAssertionPublicKeyAllowCredentialsInner]?
    public var challenge: String
    public var extensions: AnyCodable?
    public var rpId: String?
    public var timeout: Int?
    /** UserVerification This member describes the Relying Party's requirements regarding user verification for the create() operation. Eligible authenticators are filtered to only those capable of satisfying this requirement. */
    public var userVerification: String?

    public init(allowCredentials: [ProtocolCredentialAssertionPublicKeyAllowCredentialsInner]? = nil, challenge: String, extensions: AnyCodable? = nil, rpId: String? = nil, timeout: Int? = nil, userVerification: String? = nil) {
        self.allowCredentials = allowCredentials
        self.challenge = challenge
        self.extensions = extensions
        self.rpId = rpId
        self.timeout = timeout
        self.userVerification = userVerification
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case allowCredentials
        case challenge
        case extensions
        case rpId
        case timeout
        case userVerification
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(allowCredentials, forKey: .allowCredentials)
        try container.encode(challenge, forKey: .challenge)
        try container.encodeIfPresent(extensions, forKey: .extensions)
        try container.encodeIfPresent(rpId, forKey: .rpId)
        try container.encodeIfPresent(timeout, forKey: .timeout)
        try container.encodeIfPresent(userVerification, forKey: .userVerification)
    }
}

