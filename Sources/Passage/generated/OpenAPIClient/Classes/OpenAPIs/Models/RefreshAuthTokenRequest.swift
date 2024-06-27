//
// RefreshAuthTokenRequest.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct RefreshAuthTokenRequest: Codable, JSONEncodable, Hashable {

    public var refreshToken: String

    public init(refreshToken: String) {
        self.refreshToken = refreshToken
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case refreshToken = "refresh_token"
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(refreshToken, forKey: .refreshToken)
    }
}

