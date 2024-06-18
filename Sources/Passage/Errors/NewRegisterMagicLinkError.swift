import Foundation

public enum NewRegisterMagicLinkError: PassageError {
    
    case invalidIdentifier
    case unspecified
    
    public static func convert(error: Error) -> NewRegisterMagicLinkError {
        // Check if error is already proper
        if let error = error as? NewRegisterMagicLinkError {
            return error
        }
        // Handle client error
        if let errorResponse = error as? ErrorResponse {
            guard let (_, errorData) = PassageErrorData.getData(from: errorResponse) else {
                return .unspecified
            }
            if errorData.code == Model400Code.request.rawValue {
                return .invalidIdentifier
            }
            return .unspecified
        }
        return .unspecified
    }
    
}
