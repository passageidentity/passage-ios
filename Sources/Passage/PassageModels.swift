import Foundation

/// The authentication result containing the users tokens and redirect url
public struct AuthResult : Codable {
    /// The users auth_token
    public var auth_token: String?
    
    /// The users refresh_token
    public var refresh_token: String?
    
    /// The redirect url after successful authentication
    public var redirect_url: String?
}


/// Details of a Passage User
public struct PassageUser : Codable, Equatable {

    /// The user's id in the Passage System
    public var id: String
    
    /// User status,
    public var status: String?

    /// The user's email address
    public var email: String?

    /// Whether the users email has been verifier or not
    public var email_verified: Bool
    
    /// Users phone number
    public var phone: String?
    
    /// Whether the user's phone number has been verified
    public var phone_verified: Bool
    
    /// Does the user support webauthn
    public var webauthn: Bool
    
    /// Uer meta data schema
    public var user_metadata: String?
    
    /// Types of webauth - platform or passkey
    public var webauthn_types: [String]?
    
}

/// Details about a Passage user
public struct PassageUserDetails : Codable {
    /// when the user was created
    public var created_at: String
    /// when the user was last update
    public var updated_at: String
    /// status of the user
    public var status: String
    /// the user's unique id
    public var id: String
    /// user's email address
    public var email: String
    /// has the user's email been verified
    public var email_verified: Bool
    /// user's phone number
    public var phone: String
    /// has the user's phone number been verified
    public var phone_verified: Bool
    /// does the user support webauthn
    public var webauthn: Bool
    /// last time the user logged in
    public var last_login_at: String
    /// number of times the user has logged in
    public var login_count: Int
    //    var user_metadata: [String: String]
    /// Devices the user has used webauthn on
    public var webauthn_devices: [WebauthnDevice]
    /// types of webauthn the user has used - passkey or platform
    public var webauthn_types: [String]
}


/// Devices used with webauthn
public struct WebauthnDevice : Codable {
    public var id: String
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

    enum CodingKeys: String, CodingKey {
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
    }
    
    public enum AuthFallbackMethod: String {
        case magicLink = "magic_link"
        case oneTimePasscode = "otp"
    }
    
    /// Which fallback method is set in the Passage Application when Passkeys are not available
    public var authFallbackMethod: AuthFallbackMethod? {
        return AuthFallbackMethod(rawValue: authFallbackMethodString)
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
public struct DeviceInfo : Codable {
    /// The device id
    public var id: String
    /// The id of the credential this device is registered with
    public var cred_id: String
    /// The user id associated with the device
    public var user_id: String
    /// A friendly name to describe the device
    public var friendly_name: String
    /// Number of times the device has been used
    public var usage_count: Int
    /// When the device was last updated.
    public var updated_at: String
    /// When the device was initially registered
    public var created_at: String
    /// Last time the device was used.
    public var last_login_at: String
}
