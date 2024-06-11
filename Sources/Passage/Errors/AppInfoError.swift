import Foundation

public enum AppInfoError: PassageError {
    
    case appNotFound
    case unspecified
    
    public static func convert(error: Error) -> AppInfoError {
        // Check if error is already proper
        if let appInfoError = error as? AppInfoError {
            return appInfoError
        }
        // Handle client error
        if let errorResponse = error as? ErrorResponse {
            guard let (_, errorData) = PassageErrorData.getData(from: errorResponse) else {
                return .unspecified
            }
            switch errorData.code {
            case Model404Code.appNotFound.rawValue: return .appNotFound
            default: ()
            }
            return .unspecified
        }
        return .unspecified
    }
    
}
