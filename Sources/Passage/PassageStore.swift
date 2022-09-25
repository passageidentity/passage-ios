//
//  PassageStore.swift
//  Shiny
//
//  Created by blayne bayer on 8/29/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

/// Protocol for Token Storage to use with Passage
///
/// Protocl that must be implemented that can be used with
/// the PassageAuth methods to manage the users tokens
/// instead of having to manage them manually.
///
/// Login and Registration will clear existing tokens and set the new ones.
///
/// Signout will clear any existing tokens.
public protocol PassageTokenStore {
    
    /// A valid auth token
    
    var authToken: String? { get set }
    /// a valid refresh token
    var refreshToken: String? { get set }
    
    /// Set the auth token, refresh token or both from an ``AuthResult``
    /// - Parameter authResult: A ``AuthResult`` returned from a successful login or registration
    /// - Returns: Void
    func setTokens(authResult: AuthResult) -> Void
    
    /// Set the auth token, refresh token or both from the tokens passed in
    /// - Parameters:
    ///   - authToken: a valid auth token
    ///   - refreshToken: a valid refresh token
    /// - Returns: Void
    func setTokens(authToken: String?, refreshToken: String?) -> Void
    
    
    /// Clear the tokens, both auth and refresh tokens.
    func clearTokens()
    
}


public class PassageStore : PassageTokenStore {
    
    public static let shared = PassageStore()
    
    
    public var authToken: String? {
        get {
            return KeychainWrapper.standard[.authTokenKey]
        }
        set {
            if newValue == nil {
                KeychainWrapper.standard.removeObject(forKey: "passageAuthToken")
            } else {
                KeychainWrapper.standard[.authTokenKey] = newValue
            }
        }
    }
    
    public var refreshToken: String? {
        get {
            return KeychainWrapper.standard[.refreshTokenKey]
        }
        set {
            if newValue == nil {
                KeychainWrapper.standard.removeObject(forKey: "passageRefreshToken")
            }
            else {
                KeychainWrapper.standard[.refreshTokenKey] = newValue
            }
            
        }
    }
    
    private init() {
        
    }
    
    public func setTokens(authResult: AuthResult) {
        self.authToken = authResult.auth_token
        self.refreshToken = nil
    }
    
    public func setTokens(authToken: String?, refreshToken: String?) {
        self.authToken = authToken
        self.refreshToken = refreshToken
    }
    
    public func clearTokens() {
        self.authToken = nil
        self.refreshToken = nil
    }
    

}


/// Add some custom keys to the keychain
extension KeychainWrapper.Key {
    /// Custom auth token key
    static let authTokenKey: KeychainWrapper.Key = "passageAuthToken"
    /// Custom refresh token key
    static let refreshTokenKey: KeychainWrapper.Key = "passageRefreshToken"
}
