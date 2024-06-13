import Foundation

public enum GetMagicLinkStatusError: PassageError {
    
    case invalidRequest
    case magicLinkNotFound
    case unspecified
    
    public static func convert(error: Error) -> GetMagicLinkStatusError {
        // Check if error is already proper
        if let error = error as? GetMagicLinkStatusError {
            return error
        }
        // Handle client error
        if let errorResponse = error as? ErrorResponse {
            guard let (_, errorData) = PassageErrorData.getData(from: errorResponse) else {
                return .unspecified
            }
            switch errorData.code {
            case Model400Code.request.rawValue: return .invalidRequest
            case Model404Code.magicLinkNotFound.rawValue: return .magicLinkNotFound
            default: ()
            }
            return .unspecified
        }
        return .unspecified
    }
    
}
