import Foundation

public enum OneTimePasscodeActivateError: PassageError {
    
    case exceededAttempts
    case invalidRequest
    case unspecified
    case userNotActive
    
    public static func convert(error: Error) -> OneTimePasscodeActivateError {
        // Check if error is already proper
        if let error = error as? OneTimePasscodeActivateError {
            return error
        }
        // Handle client error
        if let errorResponse = error as? ErrorResponse {
            guard let (_, errorData) = PassageErrorData.getData(from: errorResponse) else {
                return .unspecified
            }
            switch errorData.code {
            case Model400Code.request.rawValue: return .invalidRequest
            case Model403Code.userNotActive.rawValue: return .userNotActive
            case "exceeded_attempts": return .exceededAttempts
            default: ()
            }
            return .unspecified
        }
        return .unspecified
    }
    
}
