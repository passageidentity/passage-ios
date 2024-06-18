import AuthenticationServices

public enum AddDeviceError: PassageError {
    
    case authorizationFailed
    case canceled
    case credentialChallengeParsingFailed
    case inactiveUser
    case invalidRequest
    case unauthorized
    case unspecified
    
    public static func convert(error: Error) -> AddDeviceError {
        // Check if error is already proper
        if let addDeviceError = error as? AddDeviceError {
            return addDeviceError
        }
        // Handle client error
        if let errorResponse = error as? ErrorResponse {
            guard let (statusCode, errorData) = PassageErrorData.getData(from: errorResponse) else {
                return .unspecified
            }
            switch errorData.code {
            case Model400Code.request.rawValue: return .invalidRequest
            case Model403Code.userNotActive.rawValue: return .inactiveUser
            default: ()
            }
            if statusCode == 401 {
                return .unauthorized
            }
            return .unspecified
        }
        // Handle authorization error
        if let authError = error as? ASAuthorizationError {
            return authError.code == .canceled ? .canceled : .authorizationFailed
        }
        return .unspecified
    }
    
}
