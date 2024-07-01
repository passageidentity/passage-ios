import AuthenticationServices
import CommonCrypto
import Security

public enum PassageSocialConnection: String {
    case apple
    case github
    case google
}

final internal class PassageSocialAuthController:
    NSObject,
    ASWebAuthenticationPresentationContextProviding,
    ASAuthorizationControllerDelegate,
    ASAuthorizationControllerPresentationContextProviding
{
    
    internal var verifier = ""
    
    private var window: UIWindow
    private var webAuthSession: ASWebAuthenticationSession?
    private var siwaContinuation: CheckedContinuation<(String, String), Error>?
    
    // MARK: INIT METHODS
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: DELEGATE METHODS
    
    // ASWebAuthentication delegate methods
    
    internal func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return window
    }
    
    // ASAuthorizationControllerDelegate delegate methods
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return window
    }
    
    internal func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard
                let authCodeData = appleIDCredential.authorizationCode,
                let authCode = String(data: authCodeData, encoding: .utf8),
                let idTokenData = appleIDCredential.identityToken,
                let idToken = String(data: idTokenData, encoding: .utf8) else
            {
                siwaContinuation?.resume(throwing: SocialAuthError.missingAppleCredentials)
                return
            }
            siwaContinuation?.resume(returning: (authCode, idToken))
        } else {
            siwaContinuation?.resume(throwing: SocialAuthError.missingAppleCredentials)
        }
    }
    
    internal func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        siwaContinuation?.resume(throwing: error)
    }
    
    // MARK: STATIC METHODS
    
    internal static func getCallbackUrlScheme(appId: String) -> String {
        return "passage-\(appId)"
    }
    
    internal static func getRandomString(length: Int) -> String {
        let characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var randomString = ""
        for _ in 0..<length {
            let randomValue = Int(arc4random_uniform(UInt32(characters.count)))
            randomString += String(
                characters[
                    characters.index(characters.startIndex, offsetBy: randomValue)
                ]
            )
        }
        return randomString
    }
    
    internal static func sha256Hash(_ str: String) -> String {
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
        let urlScheme = PassageSocialAuthController.getCallbackUrlScheme(appId: appId)
        let redirectURI = "\(urlScheme)://"
        let state = PassageSocialAuthController.getRandomString(length: 32)
        let randomString = PassageSocialAuthController.getRandomString(length: 32)
        verifier = randomString
        let codeChallenge = PassageSocialAuthController.sha256Hash(randomString)
        let codeChallengeMethod = "S256"
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "code_challenge", value: codeChallenge),
            URLQueryItem(name: "code_challenge_method", value: codeChallengeMethod),
            URLQueryItem(name: "connection_type", value: connection.rawValue)
        ]
        let params = components.url?.query ?? ""
        return params
    }
        
    internal func openSecureWebView(
        url: URL,
        callbackURLScheme: String,
        prefersEphemeralWebBrowserSession: Bool
    ) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            webAuthSession = getWebAuthSession(
                url: url,
                callbackURLScheme: callbackURLScheme,
                prefersEphemeralWebBrowserSession: prefersEphemeralWebBrowserSession,
                continuation: continuation
            )
            webAuthSession?.presentationContextProvider = self
            webAuthSession?.prefersEphemeralWebBrowserSession = prefersEphemeralWebBrowserSession
            webAuthSession?.start()
        }
    }
    
    private func getWebAuthSession(
        url: URL,
        callbackURLScheme: String,
        prefersEphemeralWebBrowserSession: Bool,
        continuation: CheckedContinuation<String, Error>
    ) -> ASWebAuthenticationSession {
        return ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: callbackURLScheme
        ) { callbackURL, error in
            guard error == nil else {
                continuation.resume(throwing: error!)
                return
            }
            guard
                let callbackURL = callbackURL,
                let components = NSURLComponents(url: callbackURL, resolvingAgainstBaseURL: true),
                let authCode = components.queryItems?.filter({$0.name == "code"}).first?.value
            else {
                continuation.resume(throwing: SocialAuthError.missingAuthCode)
                return
            }
            continuation.resume(returning: authCode)
        }
    }
    
    internal func signInWithApple() async throws -> (String, String) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let randomString = PassageSocialAuthController.getRandomString(length: 32)
        let codeChallenge = PassageSocialAuthController.sha256Hash(randomString)
        let state = PassageSocialAuthController.getRandomString(length: 32)
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = codeChallenge
        request.state = state
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        return try await withCheckedThrowingContinuation { continuation in
            self.siwaContinuation = continuation
            authorizationController.performRequests()
        }
    }
    
}
