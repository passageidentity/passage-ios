import Foundation

/// Errors thrown from the ASAuthorization Controller
public enum PassageASAuthorizationError: Error {
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

// OTP Error
public enum PassageOTPError: Error {
    case exceededAttempts
}

public enum PassageSocialError: Error {
    case missingAuthCode
    case missingAppleCredentials
}

/// Any unspecified PassageError
public enum PassageError: Error, Equatable {
    case unauthorized
    case unknown
    case userAlreadyExists
    case userDoesNotExist
    case invalidAppInfo
    case invalidAuthFallbackMethod
    case authFallbacksNotSupported
}

/// Passage Device Errors
public enum PassageDeviceError: Error {
    case notFound
}

/// Passage Settings Error - configuration errors
public enum PassageSettingsError: Error {
    case errorReadingPlist
}

/// Passage Session Errors
public enum PassageSessionError: Error {
    case loginRequired
}

public enum PassageConfigurationError: Error {
    case cannotFindPassagePlist
    case cannotFindAppId
    
    public var description: String {
        switch self {
        case .cannotFindAppId:
            return "Cannot find required Passage.plist file."
        case .cannotFindPassagePlist:
            return "Cannot find your Passage app id in your Passage.plist file"
        }
    }
}
