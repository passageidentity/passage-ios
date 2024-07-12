import Foundation

public enum HostedAuthorizationError: Error {
    case canceled
    case cannotAccessAppBundleId
    case cannotAccessAppRootViewController
    case invalidHostedAuthUrl
    case invalidHostedCallbackUrl
    case invalidHostedLogoutUrl
    case invalidHostedTokenUrl
    case missingIdToken
    case serverError
    case unauthorized
}
