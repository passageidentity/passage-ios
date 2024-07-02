import SafariServices

public enum HostedAuthorizationError: Error {
    case cannotAccessAppBundleId
    case cannotAccessAppRootViewController
    case invalidHostedAuthUrl
    case unspecified
}

final internal class HostedAuthorizationController:
    NSObject,
    SFSafariViewControllerDelegate
{
    
    // MARK: - INSTANCE PROPERTIES
    private var appInfo: AppInfo
    private var bundleId: String
    private var verifier = ""
    private var safariViewController: SFSafariViewController?
    private var hostedContinuation: CheckedContinuation<(String, String), Error>?
    private var hostedLogoutContinuation: CheckedContinuation<Void, Error>?
    private lazy var callbackUrlString: String = {
        return "\(appInfo.authOrigin)/ios/\(bundleId)/callback"
    }()
    private lazy var logoutUrlString: String = {
        return "\(appInfo.authOrigin)/ios/\(bundleId)/logout"
    }()
    
    // MARK: - INITIALIZERS
    internal init(appInfo: AppInfo) throws {
        self.appInfo = appInfo
        guard let bundleId = Bundle.main.bundleIdentifier else {
            throw HostedAuthorizationError.cannotAccessAppBundleId
        }
        self.bundleId = bundleId
    }
    
    // MARK: - INSTANCE METHODS
    @MainActor
    internal func start(in window: UIWindow) async throws -> (String, String) {
        let url = try getHostedStartUrl()
        safariViewController = SFSafariViewController(url: url)
        guard
            let safariViewController,
            let appViewController = window.rootViewController
        else {
            throw HostedAuthorizationError.cannotAccessAppRootViewController
        }
        safariViewController.delegate = self
        safariViewController.modalPresentationStyle = .pageSheet
        appViewController.present(safariViewController, animated: true)
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.hostedContinuation = continuation
        }
    }
    
    internal func finish(
        authCode: String,
        state: String,
        clientSecret: String
    ) async throws -> (AuthResult, String) {
        let url = try getHostedFinishUrl(
            authCode: authCode,
            state: state,
            clientSecret: clientSecret
        )
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            // TODO: Handle bad response.
            let decoder = JSONDecoder()
            let result = try decoder.decode(HostedAuthResult.self, from: data)
            let authResult = AuthResult(
                authToken: result.access_token,
                redirectUrl: "/",
                refreshToken: result.refresh_token,
                refreshTokenExpiration: nil // TODO: Figure out what to put here?
            )
            verifier = ""
            return (authResult, result.id_token)
        } catch {
            // TODO: Handle error cases here.
            throw HostedAuthorizationError.unspecified
        }
    }
    
    private func getHostedStartUrl() throws -> URL {
        let baseUrl = "\(appInfo.authOrigin)/authorize?"
        // TODO: Move these out of PassageSocialAuthController
        let randomString = PassageSocialAuthController.getRandomString(length: 32)
        verifier = PassageSocialAuthController.getRandomString(length: 32)
        let codeChallenge = PassageSocialAuthController.sha256Hash(randomString)
        let codeChallengeMethod = "S256"
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.queryItems = [
            URLQueryItem(name: "redirect_uri", value: callbackUrlString),
            URLQueryItem(name: "state", value: verifier),
            URLQueryItem(name: "code_challenge", value: codeChallenge),
            URLQueryItem(name: "code_challenge_method", value: codeChallengeMethod),
            URLQueryItem(name: "client_id", value: appInfo.id),
            URLQueryItem(name: "scope", value: "openid"),
            URLQueryItem(name: "response_type", value: "code"),
        ]
        guard let url = urlComponents?.url else {
            throw HostedAuthorizationError.invalidHostedAuthUrl
        }
        return url
    }
    
    private func getHostedFinishUrl(
        authCode: String,
        state: String,
        clientSecret: String
    ) throws -> URL {
        let urlString = "\(appInfo.authOrigin)/token"
        guard var urlComponents = URLComponents(string: urlString) else {
            throw HostedAuthorizationError.invalidHostedAuthUrl
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: authCode),
            URLQueryItem(name: "client_id", value: appInfo.id),
            URLQueryItem(name: "verifier", value: state),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "redirect_uri", value: callbackUrlString)
        ]
        guard let url = urlComponents.url else {
            throw HostedAuthorizationError.invalidHostedAuthUrl
        }
        return url
    }
    
    @MainActor
    internal func logout(in window: UIWindow, idToken: String) async throws {
        let url = try getLogoutUrl(idToken: idToken)
        safariViewController = SFSafariViewController(url: url)
        guard
            let safariViewController,
            let appViewController = window.rootViewController
        else {
            throw HostedAuthorizationError.cannotAccessAppRootViewController
        }
        safariViewController.delegate = self
        safariViewController.modalPresentationStyle = .pageSheet
        appViewController.present(safariViewController, animated: true)
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.hostedLogoutContinuation = continuation
            self?.verifier = ""
        }
    }
    
    private func getLogoutUrl(idToken: String) throws -> URL {
        let urlString = "\(appInfo.authOrigin)/logout"
        guard var urlComponents = URLComponents(string: urlString) else {
            throw HostedAuthorizationError.invalidHostedAuthUrl
        }
        verifier = PassageSocialAuthController.getRandomString(length: 32)
        urlComponents.queryItems = [
            URLQueryItem(name: "id_token_hint", value: idToken),
            URLQueryItem(name: "client_id", value: appInfo.id),
            URLQueryItem(name: "state", value: verifier),
            URLQueryItem(name: "post_logout_redirect_uri", value: logoutUrlString)
        ]
        guard let url = urlComponents.url else {
            throw HostedAuthorizationError.invalidHostedAuthUrl
        }
        return url
    }
    
    // MARK: - SFSafariViewControllerDelegate METHODS
    internal func safariViewController(
        _ controller: SFSafariViewController,
        initialLoadDidRedirectTo URL: URL
    ) {
        if
            URL.absoluteString.contains(callbackUrlString),
            let components = NSURLComponents(url: URL, resolvingAgainstBaseURL: true),
            let code = components.queryItems?.filter({$0.name == "code"}).first?.value,
            let state = components.queryItems?.filter({$0.name == "state"}).first?.value,
            state == verifier // TODO: Throw specific error for bad state.
        {
            hostedContinuation?.resume(returning: (code, state))
            controller.dismiss(animated: true, completion: nil)
        } else if URL.absoluteString.contains(logoutUrlString) {
            hostedLogoutContinuation?.resume(returning: ())
            controller.dismiss(animated: true, completion: nil)
        }
        // TODO: How to handle error case?
    }
    
}

struct HostedAuthResult: Codable {
    let access_token: String
    let id_token: String
    let state: String
    let token_type: String
    let expires_in: Int
    let refresh_token: String?
}
