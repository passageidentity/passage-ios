//
// LayoutConfig.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

public struct LayoutConfig: Codable, JSONEncodable, Hashable {

    public var h: Int
    public var id: String
    public var w: Int
    public var x: Int
    public var y: Int

    public init(h: Int, id: String, w: Int, x: Int, y: Int) {
        self.h = h
        self.id = id
        self.w = w
        self.x = x
        self.y = y
    }

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case h
        case id
        case w
        case x
        case y
    }

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(h, forKey: .h)
        try container.encode(id, forKey: .id)
        try container.encode(w, forKey: .w)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
    }
}

