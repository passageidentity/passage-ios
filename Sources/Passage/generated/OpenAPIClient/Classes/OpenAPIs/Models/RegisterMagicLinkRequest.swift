//
// RegisterMagicLinkRequest.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct RegisterMagicLinkRequest: Codable, JSONEncodable, Hashable {

    /** valid email or E164 phone number */
    public var identifier: String
    /** language of the email or SMS to send (optional) */
    public var language: String?
    /** path relative to the app's auth_origin (optional) */
    public var magicLinkPath: String?

    public init(identifier: String, language: String? = nil, magicLinkPath: String? = nil) {
        self.identifier = identifier
        self.language = language
        self.magicLinkPath = magicLinkPath
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case identifier
        case language
        case magicLinkPath = "magic_link_path"
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encodeIfPresent(language, forKey: .language)
        try container.encodeIfPresent(magicLinkPath, forKey: .magicLinkPath)
    }
}

