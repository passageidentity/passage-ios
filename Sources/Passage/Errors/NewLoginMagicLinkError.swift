import Foundation

public enum NewLoginMagicLinkError: PassageError {
    
    case invalidIdentifier
    case unspecified
    
    public static func convert(error: Error) -> NewLoginMagicLinkError {
        // Check if error is already proper
        if let error = error as? NewLoginMagicLinkError {
            return error
        }
        // Handle client error
        if let errorResponse = error as? ErrorResponse {
            guard let (_, errorData) = PassageErrorData.getData(from: errorResponse) else {
                return .unspecified
            }
            switch errorData.code {
            case Model400Code.request.rawValue: return .invalidIdentifier
            default: ()
            }
            return .unspecified
        }
        return .unspecified
    }
    
}
