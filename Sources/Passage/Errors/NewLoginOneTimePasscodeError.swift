import Foundation

public enum NewLoginOneTimePasscodeError: PassageError {
    
    case invalidIdentifier
    case unspecified
    /// Thrown when a user with provided identifier does not exist.
    case userDoesNotExist
    
    public static func convert(error: Error) -> NewLoginOneTimePasscodeError {
        // Check if error is already proper
        if let error = error as? NewLoginOneTimePasscodeError {
            return error
        }
        // Handle client error
        if let errorResponse = error as? ErrorResponse {
            guard let (_, errorData) = PassageErrorData.getData(from: errorResponse) else {
                return .unspecified
            }
            switch errorData.code {
            case Model400Code.request.rawValue: return .invalidIdentifier
            case Model404Code.userNotFound.rawValue: return .userDoesNotExist
            default: ()
            }
            return .unspecified
        }
        return .unspecified
    }
    
}
