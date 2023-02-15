//
//  File.swift
//  
//
//  Created by blayne bayer on 8/31/22.
//

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
public struct AppInfo : Codable, Equatable {
    
    /// The id of the Passage Application
    public var id: String
    
    
    /// If this is an ephemeral app
    public var ephemeral: Bool
    
    
    /// The name of the Passage Application
    public var name: String
    
    
    /// The Pasage Application redirect url
    public var redirect_url: String
    
    
    /// The Login URL of the Passage Application
    public var login_url: String
    
    
    /// Allowed identifier (email or phone)
    public var allowed_identifier: String
    
    /// The identifier type that is required
    public var required_identifier: String
    
    
    /// The Passage Applications auth origin
    public var auth_origin: String
    
    
    /// Whether the Passage Application requires email verificiation
    public var require_email_verification: Bool
    
    
    /// Whether the Passage Application required identifier verification when registering
    public var require_identifier_verification: Bool
    
    
    /// How long is the auth token valid
    public var session_timeout_length: Int

    //    var user_metadata_schema: [String: String]

    //    var layouts: [String: String]
    
    
    /// Allow public signup
    public var public_signup: Bool
}


/// Describes a magic link
public struct MagicLink : Codable {
    /// id of the magic link
    public var id: String
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
