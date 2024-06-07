import AnyCodable
import Foundation

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
    /// social accounts connected to your user
    public let socialConnections: UserSocialConnections?
    /// status of the user
    public let status: String
    /// social accounts connected to your user
    public let socialConnections: UserSocialConnections?
    /// when the user was last update
    public let updatedAt: String?
    /// your Passage app's custom user metadata
    public let userMetadata: AnyCodable?
    /// does the user support webauthn
    public let webauthn: Bool?
    /// Devices the user has used webauthn on
    public let webauthnDevices: [DeviceInfo]?
    /// types of webauthn the user has used - passkey or platform
    public let webauthnTypes: [String]?
}

/// Struct describing a Passage Application
public typealias AppInfo = App

/// Describes a one time passcode
public struct OneTimePasscode {
    /// id of the one time passcode
    public var id: String
    enum CodingKeys: String, CodingKey {
        case id = "otp_id"
    }
}

/// Information about a registered device
public typealias DeviceInfo = Credential

public struct PasskeyCreationOptions {
    public let authenticatorAttachment: AuthenticatorAttachment
    
    public init(authenticatorAttachment: AuthenticatorAttachment) {
        self.authenticatorAttachment = authenticatorAttachment
    }
}
