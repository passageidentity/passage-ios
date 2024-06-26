//
// UserStatus.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

/** User status: active, inactive, pending */
public enum UserStatus: String, Codable, CaseIterable {
    case active = "active"
    case inactive = "inactive"
    case pending = "pending"
    case statusUnavailable = ""
}
