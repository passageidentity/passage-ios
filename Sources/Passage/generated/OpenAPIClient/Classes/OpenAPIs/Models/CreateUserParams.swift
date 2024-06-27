//
// CreateUserParams.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct CreateUserParams: Codable, JSONEncodable, Hashable {

    public var identifier: String
    public var userMetadata: AnyCodable?

    public init(identifier: String, userMetadata: AnyCodable? = nil) {
        self.identifier = identifier
        self.userMetadata = userMetadata
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case identifier
        case userMetadata = "user_metadata"
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encodeIfPresent(userMetadata, forKey: .userMetadata)
    }
}

