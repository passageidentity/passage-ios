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
            if errorData.code == Model404Code.appNotFound.rawValue {
                return .appNotFound
            }
            return .unspecified
        }
        return .unspecified
    }
    
}
