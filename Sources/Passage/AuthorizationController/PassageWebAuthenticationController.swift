import AuthenticationServices
import CommonCrypto
import Security

public enum PassageSocialConnection: String {
    case apple
    case github
    case google
}

final internal class PassageWebAuthenticationController: NSObject, ASWebAuthenticationPresentationContextProviding {
    
    internal var verifier = ""
    
    private var webAuthSession: ASWebAuthenticationSession?
    private var window: UIWindow
    
    // MARK: INIT METHODS
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: DELEGATE METHODS
    
    internal func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return window
    }
    
    // MARK: STATIC METHODS
    
    private static func getRandomString(length: Int) -> String {
        let characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var randomString = ""
        for _ in 0..<length {
            let randomValue = Int(arc4random_uniform(UInt32(characters.count)))
            randomString += String(characters[characters.index(characters.startIndex, offsetBy: randomValue)])
        }
        return randomString
    }
    
    private static func sha256Hash(_ str: String) -> String {
        let data = Data(str.utf8)
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        let base64EncodedString = Data(hash).base64EncodedString()
        let base64URL = base64EncodedString
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return base64URL
    }
    
    // MARK: INSTANCE METHODS
    
    internal func getSocialAuthQueryParams(appId: String, connection: PassageSocialConnection) -> String {
        let redirectURI = "\(appId)://"
        let state = PassageWebAuthenticationController.getRandomString(length: 32)
        let randomString = PassageWebAuthenticationController.getRandomString(length: 32)
        verifier = randomString
        let codeChallenge = PassageWebAuthenticationController.sha256Hash(randomString)
        let codeChallengeMethod = "S256"
        let params = """
            redirect_uri=\(redirectURI)&
            state=\(state)&
            code_challenge=\(codeChallenge)&
            code_challenge_method=\(codeChallengeMethod)&
            connection_type=\(connection.rawValue)
        """
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "\n", with: "")
        return params
    }
        
    internal func openSecureWebView(
        url: URL,
        callbackURLScheme: String,
        prefersEphemeralWebBrowserSession: Bool
    ) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            webAuthSession = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackURLScheme)
                { callbackURL, error in
                    guard error == nil else {
                        continuation.resume(throwing: error!)
                        return
                    }
                    guard
                        let callbackURL = callbackURL,
                        let components = NSURLComponents(url: callbackURL, resolvingAgainstBaseURL: true),
                        let authCode = components.queryItems?.filter({$0.name == "code"}).first?.value
                    else {
                        continuation.resume(throwing: PassageSocialError.missingAuthCode)
                        return
                    }
                    continuation.resume(returning: authCode)
                }
            webAuthSession?.presentationContextProvider = self
            webAuthSession?.prefersEphemeralWebBrowserSession = prefersEphemeralWebBrowserSession
            webAuthSession?.start()
        }
    }
    
}
