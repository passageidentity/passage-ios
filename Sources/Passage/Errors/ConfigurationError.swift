import Foundation

public enum PassageConfigurationError: Error {
    case cannotFindPassagePlist
    case cannotFindAppId
    
    public var description: String {
        switch self {
        case .cannotFindAppId:
            return "Cannot find required Passage.plist file."
        case .cannotFindPassagePlist:
            return "Cannot find your Passage app id in your Passage.plist file"
        }
    }
}
