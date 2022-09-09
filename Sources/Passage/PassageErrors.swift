//
//  PassageErrors.swift
//  Shiny
//
//  Created by Ricky C Padilla on 8/8/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation


/// Errors thrown from the ASAuthorization Controller
public enum PassageASAuthorizationError : Error {
    case authorizationTypeUnknown
    case canceled
    case credentialRegistration
    case loginFinish
    case invalidStartResponse
    case unknownAuthorizationType
    case unknown
}

/// Registration Errors
public enum PassageRegisterError: Error {
    case publicRegistrationDisabled
    case userAlreadyExists
}

// Login Error
public enum PassageLoginError: Error {
    case identifierRequired
}

/// Any unspecified PassageError
public enum PassageError: Error {
    case unauthorized
    case unknown
    case userAlreadyExists
    case userDoesNotExist
    case invalidAppInfo
}

/// Passage Device Errors
public enum PassageDeviceError : Error {
    case notFound
}

/// Passage Settings Error - configuration errors
public enum PassageSettingsError: Error {
    case errorReadingPlist
}
