import Foundation

public enum MagicLinkActivateError: PassageError {
    
    case magicLinkNotFound
    case userNotActive
    case unspecified
    
    public static func convert(error: Error) -> MagicLinkActivateError {
        // Check if error is already proper
        if let error = error as? MagicLinkActivateError {
            return error
        }
        // Handle client error
        if let errorResponse = error as? ErrorResponse {
            guard let (_, errorData) = PassageErrorData.getData(from: errorResponse) else {
                return .unspecified
            }
            switch errorData.code {
            case Model403Code.userNotActive.rawValue: return .userNotActive
            case Model404Code.magicLinkNotFound.rawValue: return .magicLinkNotFound
            default: ()
            }
            return .unspecified
        }
        return .unspecified
    }
    
}
