import Foundation

public enum PassageTokenError: PassageError {
    
    case loginRequired
    case unauthorized
    case unspecified
    
    public static func convert(error: Error) -> PassageTokenError {
        // Check if error is already proper
        if let error = error as? PassageTokenError {
            return error
        }
        // Handle client error
        if let errorResponse = error as? ErrorResponse {
            guard let (statusCode, _) = PassageErrorData.getData(from: errorResponse) else {
                return .unspecified
            }
            switch statusCode {
            case 401: return .unauthorized
            default: ()
            }
            return .unspecified
        }
        return .unspecified
    }
    
}
