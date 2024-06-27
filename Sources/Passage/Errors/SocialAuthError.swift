import AuthenticationServices

public enum SocialAuthError: PassageError {
    
    case authorizationFailed
    case connectionNotSetupForPassageApp
    case inactiveUser
    case invalidRequest
    case invalidUrl
    case missingAppleCredentials
    case missingAuthCode
    case unspecified
    
    public static func convert(error: Error) -> SocialAuthError {
        // Check if error is already proper
        if let socialError = error as? SocialAuthError {
            return socialError
        }
        // Handle client error
        if let errorResponse = error as? ErrorResponse {
            guard let (_, errorData) = PassageErrorData.getData(from: errorResponse) else {
                return .unspecified
            }
            switch errorData.code {
            case Model400Code.request.rawValue: return .invalidRequest
            case Model403Code.identifierNotVerified.rawValue: return .inactiveUser
            default: ()
            }
            return .unspecified
        }
        // Handle authorization error
        if error is ASAuthorizationError {
            print(error)
            return .authorizationFailed
        }
        return .unspecified
    }
    
}
