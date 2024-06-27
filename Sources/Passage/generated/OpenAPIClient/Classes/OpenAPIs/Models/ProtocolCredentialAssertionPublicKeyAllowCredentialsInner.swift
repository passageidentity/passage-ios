//
// ProtocolCredentialAssertionPublicKeyAllowCredentialsInner.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct ProtocolCredentialAssertionPublicKeyAllowCredentialsInner: Codable, JSONEncodable, Hashable {

    /** CredentialID The ID of a credential to allow/disallow. */
    public var id: String
    /** The authenticator transports that can be used. */
    public var transports: [String]?
    /** The valid credential types. */
    public var type: String

    public init(id: String, transports: [String]? = nil, type: String) {
        self.id = id
        self.transports = transports
        self.type = type
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case id
        case transports
        case type
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(transports, forKey: .transports)
        try container.encode(type, forKey: .type)
    }
}

