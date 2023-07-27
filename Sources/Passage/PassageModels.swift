import Foundation

/// The authentication result containing the users tokens and redirect url
public struct AuthResult: Codable {
    /// The user's auth token
    public let authToken: String
    /// The redirect url after successful authentication
    public let redirectURL: String
    /// The user's refresh token
    public let refreshToken: String?
    /// The expiration of the user's refresh token
    public let refreshTokenExpiration: Int?
    
    internal enum CodingKeys: String, CodingKey {
        case authToken = "auth_token"
        case redirectURL = "redirect_url"
        case refreshToken = "refresh_token"
        case refreshTokenExpiration = "refresh_token_expiration"
    }
}

/// Information about a Passage user
public struct PassageUserInfo: Codable {
    /// when the user was created
    public let createdAt: String?
    /// user's email address
    public let email: String?
    /// has the user's email been verified
    public let emailVerified: Bool
    /// the user's unique id
    public let id: String
    /// last time the user logged in
    public let lastLoginAt: String?
    /// number of times the user has logged in
    public let loginCount: Int?
    /// user's phone number
    public let phone: String?
    /// has the user's phone number been verified
    public let phoneVerified: Bool
    /// status of the user
    public let status: String
    /// when the user was last update
    public let updatedAt: String?
    /// does the user support webauthn
    public let webauthn: Bool?
    /// Devices the user has used webauthn on
    public let webauthnDevices: [DeviceInfo]?
    /// types of webauthn the user has used - passkey or platform
    public let webauthnTypes: [String]?
    
    internal let codableUserMetadata: CodableUserMetadata?
    
    internal enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case email
        case emailVerified = "email_verified"
        case id
        case lastLoginAt = "last_login_at"
        case loginCount = "login_count"
        case phone
        case phoneVerified = "phone_verified"
        case status
        case updatedAt = "updated_at"
        case codableUserMetadata = "user_metadata"
        case webauthn
        case webauthnDevices = "webauthn_devices"
        case webauthnTypes = "webauthn_types"
    }
    
    /// Custom metadata collected about the user
    public var userMetadata: [String: Any]? {
        guard let codableUserMetadata else { return nil }
        var dict: [String: Any] = [:]
        for (key, value) in codableUserMetadata {
            switch value {
            case .double(let num):
                dict[key] = num
            case .string(let str):
                dict[key] = str
            case .bool(let bool):
                dict[key] = bool
            case .none?:
                dict[key] = NSNull()
            default:
                break
            }
        }
        return dict
    }
}

internal typealias CodableUserMetadata = [String: MetadataValue?]

internal enum MetadataValue: Codable, Equatable {
    case double(Double)
    case string(String)
    case bool(Bool)
    case none
    
    public init(from decoder: Decoder) {
        let container = try? decoder.singleValueContainer()
        if let x = try? container?.decode(Double.self) {
            self = .double(x)
        } else if let x = try? container?.decode(Bool.self) {
            self = .bool(x)
        } else if let x = try? container?.decode(String.self) {
            self = .string(x)
        } else {
            self = .none
        }
    }
    
    public func encode(to encoder: Encoder) {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try? container.encode(x)
        case .string(let x):
            try? container.encode(x)
        case .bool(let x):
            try? container.encode(x)
        case .none:
            try? container.encodeNil()
        }
    }
}

/// Struct describing a Passage Application
public struct AppInfo: Codable, Equatable {
    /// Allowed identifier (email or phone)
    public let allowedIdentifier: String
    /// String representation of which fallback method is set in the Passage Application when Passkeys are not available
    internal let authFallbackMethodString: String
    /// The Passage Applications auth origin
    public let authOrigin: String
    /// If this is an ephemeral app
    public let ephemeral: Bool
    /// The id of the Passage Application
    public let id: String
    /// The Login URL of the Passage Application
    public let loginURL: String
    /// The name of the Passage Application
    public let name: String
    /// Allow public signup
    public let publicSignup: Bool
    /// The Pasage Application redirect url
    public let redirectURL: String
    /// The identifier type that is required
    public let requiredIdentifier: String
    /// Whether the Passage Application requires email verificiation
    public let requireEmailVerification: Bool
    /// Whether the Passage Application required identifier verification when registering
    public let requireIdentifierVerification: Bool
    /// How long is the auth token valid
    public let sessionTimeoutLength: Int
    /// Custom user metadata schema the app collects
    public let userMetadataSchema: [UserMetadataSchema]?

    internal enum CodingKeys: String, CodingKey {
        case allowedIdentifier = "allowed_identifier"
        case authFallbackMethodString = "auth_fallback_method"
        case authOrigin = "auth_origin"
        case ephemeral
        case id
        case loginURL = "login_url"
        case name
        case publicSignup = "public_signup"
        case redirectURL = "redirect_url"
        case requiredIdentifier = "required_identifier"
        case requireEmailVerification = "require_email_verification"
        case requireIdentifierVerification = "require_identifier_verification"
        case sessionTimeoutLength = "session_timeout_length"
        case userMetadataSchema = "user_metadata_schema"
    }
    
    public enum AuthFallbackMethod: String {
        case magicLink = "magic_link"
        case oneTimePasscode = "otp"
        case none = "none"
    }
    
    /// Which fallback method is set in the Passage Application when Passkeys are not available
    public var authFallbackMethod: AuthFallbackMethod? {
        return AuthFallbackMethod(rawValue: authFallbackMethodString)
    }
    
}

public struct UserMetadataSchema: Codable, Equatable {
    public let fieldName: String?
    public let friendlyName: String?
    public let id: String?
    public let profile: Bool?
    public let registration: Bool?
    public let type: String?
    
    internal enum CodingKeys: String, CodingKey {
        case fieldName = "field_name"
        case friendlyName = "friendly_name"
        case id
        case profile
        case registration
        case type
    }
}

public protocol AuthFallbackResult: Codable {
    var id: String { get set }
}

/// Describes a magic link
public struct MagicLink: AuthFallbackResult {
    /// id of the magic link
    public var id: String
}

/// Describes a one time passcode
public struct OneTimePasscode: AuthFallbackResult {
    /// id of the one time passcode
    public var id: String
    enum CodingKeys: String, CodingKey {
        case id = "otp_id"
    }
}

/// Information about a registered device
public struct DeviceInfo: Codable {
    /// When the device was initially registered
    public let createdAt: String
    /// The id of the credential this device is registered with
    public let credId: String
    /// A friendly name to describe the device
    public let friendlyName: String
    /// The device id
    public let id: String
    /// Last time the device was used.
    public let lastLoginAt: String
    /// When the device was last updated.
    public let updatedAt: String?
    /// Number of times the device has been used
    public let usageCount: Int?
    /// The user id associated with the device
    public let userId: String
    
    internal enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case credId = "cred_id"
        case friendlyName = "friendly_name"
        case id
        case lastLoginAt = "last_login_at"
        case updatedAt = "updated_at"
        case usageCount = "usage_count"
        case userId = "user_id"
    }
}
