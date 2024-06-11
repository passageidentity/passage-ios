import Foundation

public enum UserError: PassageError {
    
    case inactiveUser
    case invalidRequest
    case userNotFound
    case unauthorized
    case unspecified
    
    public static func convert(error: Error) -> UserError {
        // Check if error is already proper
        if let userError = error as? UserError {
            return userError
        }
        // Handle client error
        if let errorResponse = error as? ErrorResponse {
            guard let (statusCode, errorData) = PassageErrorData.getData(from: errorResponse) else {
                return .unspecified
            }
            switch errorData.code {
            case Model400Code.request.rawValue: return .invalidRequest
            case Model403Code.userNotActive.rawValue: return .inactiveUser
            case Model404Code.userNotFound.rawValue: return .userNotFound
            default: ()
            }
            if statusCode == 401 {
                return .unauthorized
            }
            return .unspecified
        }
        return .unspecified
    }
    
}
