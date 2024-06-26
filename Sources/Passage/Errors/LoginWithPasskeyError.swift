import AuthenticationServices

public enum LoginWithPasskeyError: PassageError {
    
    /// The credential manager could not authorize the request.
    case authorizationFailed
    /// The user intentionally canceled the operation and chose not to register the credential.
    case canceled
    /// Thrown when no identifier is provided and login fails.
    case discoverableLoginFailed
    /// Thrown because of a bad request, typically when an invalid identifier is provided.
    case invalidRequest
    /// Thrown because of an issue with the passkey credential.
    case webauthnLoginFailed
    
    case unspecified
    /// Thrown when a user with provided identifier does not exist.
    case userDoesNotExist
    /// Thrown when the user is not active.
    case userNotActive
    
    public static func convert(error: Error) -> LoginWithPasskeyError {
        // Check if error is already proper
        if let error = error as? LoginWithPasskeyError {
            return error
        }
        // Handle client error
        if let errorResponse = error as? ErrorResponse {
            guard let (_, errorData) = PassageErrorData.getData(from: errorResponse) else {
                return .unspecified
            }
            switch errorData.code {
            case Model400Code.request.rawValue: return .invalidRequest
            case Model401Code.discoverableLoginFailed.rawValue: return .discoverableLoginFailed
            case Model401Code.webauthnLoginFailed.rawValue: return .webauthnLoginFailed
            case Model403Code.userNotActive.rawValue: return .userNotActive
            default: ()
            }
            if errorData.error == "user does not exist" {
                return .userDoesNotExist
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
