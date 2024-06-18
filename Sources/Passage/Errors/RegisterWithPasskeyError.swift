import AuthenticationServices

public enum RegisterWithPasskeyError: PassageError {
    
    /// The credential manager could not authorize the request.
    case authorizationFailed
    /// The user intentionally canceled the operation and chose not to register the credential.
    case canceled
    /// Thrown because of a bad request, typically when an invalid identifier is provided.
    case invalidRequest
    /// Thrown because of an issue with the passkey credential.
    case webauthnLoginFailed
    
    case unspecified
    
    public static func convert(error: Error) -> RegisterWithPasskeyError {
        // Check if error is already proper
        if let error = error as? RegisterWithPasskeyError {
            return error
        }
        // Handle client error
        if let errorResponse = error as? ErrorResponse {
            guard let (_, errorData) = PassageErrorData.getData(from: errorResponse) else {
                return .unspecified
            }
            switch errorData.code {
            case Model400Code.request.rawValue: return .invalidRequest
            case Model401Code.webauthnLoginFailed.rawValue: return .webauthnLoginFailed
            default: ()
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
