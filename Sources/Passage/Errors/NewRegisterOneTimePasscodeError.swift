import Foundation

public enum NewRegisterOneTimePasscodeError: PassageError {
    
    case invalidIdentifier
    case unspecified
    /// Thrown when a user with provided identifier already exists.
    case userAlreadyExists
    
    public static func convert(error: Error) -> NewRegisterOneTimePasscodeError {
        // Check if error is already proper
        if let error = error as? NewRegisterOneTimePasscodeError {
            return error
        }
        // Handle client error
        if let errorResponse = error as? ErrorResponse {
            guard let (_, errorData) = PassageErrorData.getData(from: errorResponse) else {
                return .unspecified
            }
            if errorData.code == Model400Code.request.rawValue {
                if errorData.error == "user: already exists." {
                    return .userAlreadyExists
                } else {
                    return .invalidIdentifier
                }
            }
            return .unspecified
        }
        return .unspecified
    }
    
}
