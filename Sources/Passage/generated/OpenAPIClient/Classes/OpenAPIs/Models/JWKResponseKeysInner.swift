//
// JWKResponseKeysInner.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct JWKResponseKeysInner: Codable, JSONEncodable, Hashable {

    /** the algorithm for the key */
    public var alg: String
    /** the exponent for the standard pem */
    public var e: String
    /** the unique identifier for the key */
    public var kid: String
    /** the key type (https://datatracker.ietf.org/doc/html/rfc7518) */
    public var kty: String
    /** the modulus for a standard pem */
    public var n: String
    /** how the key is meant to be used (i.e. 'sig' represents signature) */
    public var use: String

    public init(alg: String, e: String, kid: String, kty: String, n: String, use: String) {
        self.alg = alg
        self.e = e
        self.kid = kid
        self.kty = kty
        self.n = n
        self.use = use
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case alg
        case e
        case kid
        case kty
        case n
        case use
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(alg, forKey: .alg)
        try container.encode(e, forKey: .e)
        try container.encode(kid, forKey: .kid)
        try container.encode(kty, forKey: .kty)
        try container.encode(n, forKey: .n)
        try container.encode(use, forKey: .use)
    }
}

