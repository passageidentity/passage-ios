import AuthenticationServices
import os

public class PassageAuth {
    
    // MARK: Instance Properties
    
    /// A token store that implements ``PassageTokenStore``
    ///
    /// Used by class methods to manage the tokens when logging in, registering, etc
    public var tokenStore: PassageTokenStore;
    
    // MARK: Instance Initializers
    
    
    /// Initialize PassageAuth with the ``PassageStore`` token store that implements ``PassageTokenStore``
    public init() {
        self.tokenStore = PassageStore.shared
    }
    
    
    /// Initialize PassageAuth with a class that implements ``PassageTokenStore``
    /// - Parameter tokenStore: token store class that implements ``PassageTokenStore``
    public init(tokenStore: PassageTokenStore) {
        self.tokenStore = tokenStore
    }
    
    public init(appId: String) {
        self.tokenStore = PassageStore.shared
        PassageSettings.shared.appId = appId
    }
    
    public init(appId: String, tokenStore: PassageTokenStore) {
        self.tokenStore = tokenStore
        PassageSettings.shared.appId = appId
    }
    
    // MARK: - Static Properties
    static var appId = {
        return PassageSettings.shared.appId ?? ""
    }()
    
    // MARK: Instance Public Methods
    
    /// Start the Passkey Autofill Service
    ///
    /// You should call this as early in your View lifecycle as possible. Make sure your input field has it's textContentType set to username.
    ///
    /// - Parameters:
    ///   - anchor: Usually set to Window on your View.
    ///   - onSuccess: function to run on successful Passkey login, this method should update the UI to a logged in state
    ///   - onError: function to run if an error occures on Passkey login.
    ///   - onCancel: function to run if the user cancels the Passkey login
    /// - Returns: Void
    @available(iOS 16.0, *)
    public func beginAutoFill(anchor: ASPresentationAnchor, onSuccess:  ((AuthResult) -> Void)?, onError: ((Error) -> Void)?, onCancel: (() -> Void)?) async throws -> Void {
        self.clearTokens()

        func onAutofillSuccess(authResult: AuthResult) -> Void {

            self.setTokensFromAuthResult(authResult: authResult)
            if let unwrappedOnSuccess = onSuccess {
                unwrappedOnSuccess(authResult)
            }

        }
        try await PassageAutofillAuthorizationController.shared.begin(anchor: anchor, onSuccess: onAutofillSuccess, onError: onError, onCancel: onCancel)

    }
    
    /// Login a user using a Passkey
    ///
    /// NOTE: Only available on iOS 16+.
    ///
    /// If the user is authenticated the tokens will be stored in the tokenStore on the instance.
    ///
    /// Prompts a user to login to your app using a Passkey. This functions handles the WebAuthn interactions with Passage and the user's browser and device.
    ///
    /// When called will show a list of Passkeys for the user to select from and will
    /// then login with the selected PassKey.
    ///
    /// If the user has no passkeys a PassageLoginError.canceledOrNoPasskey will be thrown.
    ///
    /// This would be a good time to let them enter their identifier and get a login magic link or register
    /// for a new account.
    /// - Parameter identifier: The user's email, phone number, or other unique id
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageAPIError``,``PassageASAuthorizationError``, ``PassageError``
    @available(iOS 16.0, *)
    public func loginWithPasskey(identifier: String? = nil) async throws -> AuthResult {
        self.clearTokens()
        let authResult = try await PassageAuth.loginWithPasskey(identifier: identifier)
        self.setTokensFromAuthResult(authResult: authResult)
        return authResult
    }
    
    /// Login by sending the user a magic link.
    ///
    /// Any tokens stored in the tokenStore on the instance will be cleared before sending the magic link.
    ///
    /// - Parameters:
    ///   - identifier: string - email or phone number, depending on your app settings
    /// - Returns: ``MagicLink``
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public func loginWithMagicLink(identifier: String) async throws -> MagicLink? {
        self.clearTokens()
        let magicLink = try await PassageAuth.loginWithMagicLink(identifier: identifier)
        return magicLink
    }
    
    /// Sign out the current user. If the app is configured to use refresh tokens the user's current session will be signed out.
    ///
    /// Will clear the tokens from the tokenStore set on the instance.
    ///
    /// - Returns: Void
    public func signOut() async throws -> Void {
        let refreshToken = self.tokenStore.refreshToken
        if let unwrappedRefreshToken = refreshToken {
            try await PassageAuth.signOut(refreshToken: unwrappedRefreshToken)
        }
        self.clearTokens()
    }
    
    
    /// Completes a magic link login workflow by activating the magic link.
    ///
    /// The magic link is in the psg_magic_link query parameter when a user clicks the link in their email or text.
    ///
    /// Upon successful activation the tokens will be stored in the tokenStore on the instance.
    ///
    /// - Parameter userMagicLink: string - full magic link that starts with "ml" (sent via email or text to the user)
    /// - Returns: ``AuthResult`` The AuthResult object contains an authentication token (JWT) and redirect URL. The auth token should be used on all subsequent authenticated requests to the app. The redirect URL specifies the route that users should be redirected to after completed registration or login
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public func magicLinkActivate(userMagicLink: String) async throws -> AuthResult {
        self.clearTokens()
        let authResult = try await PassageAuth.magicLinkActivate(userMagicLink: userMagicLink)
        self.setTokensFromAuthResult(authResult: authResult)
        return authResult
    }
    
    /// Activates a One-Time Passcode
    ///
    /// Upon successful activation the tokens will be stored in the tokenStore on the instance.
    ///
    /// - Parameter otp: string - The OTP provided by your user
    /// - Parameter otpId: string - The OTP id returned from login or register method
    /// - Returns: ``AuthResult`` The AuthResult object contains an authentication token (JWT) and redirect URL. The auth token should be used on all subsequent authenticated requests to the app. The redirect URL specifies the route that users should be redirected to after completed registration or login
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public func oneTimePasscodeActivate(otp: String, otpId: String) async throws -> AuthResult {
        clearTokens()
        let authResult = try await PassageAuth.oneTimePasscodeActivate(otp: otp, otpId: otpId)
        setTokensFromAuthResult(authResult: authResult)
        return authResult
    }
    
    /// Authorizes user via a supported third-party social provider.
    ///
    /// Using `PassageSocialConnection.apple` connection triggers the native Sign in with Apple UI, while all other connections trigger a secure web view.
    ///
    /// - Parameters:
    ///   - connection: PassageSocialConnection - the Social connection to use for authorization
    ///   - window: UIWindow - the window used as context for presenting the secured web view
    ///   - prefersEphemeralWebBrowserSession: Bool - Set prefersEphemeralWebBrowserSession to true to request that the
    ///   browser doesn’t share cookies or other browsing data between the authentication session and the user’s normal browser session.
    ///   Defaults to false.
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageSocialError``,  ``PassageAPIError``, ``PassageError``
    public func authorize(
        with connection: PassageSocialConnection,
        in window: UIWindow,
        prefersEphemeralWebBrowserSession: Bool = false
    ) async throws -> AuthResult {
        clearTokens()
        let authResult = try await PassageAuth.authorize(
            with: connection,
            in: window,
            prefersEphemeralWebBrowserSession: prefersEphemeralWebBrowserSession
        )
        setTokensFromAuthResult(authResult: authResult)
        return authResult
    }
    
    /// Checks the status of a magic link to see if it has been activated.
    ///
    /// Upon successful activation the tokens will be stored in the tokenStore on the instance.
    ///
    /// - Parameter id: string - ID of the magic link (from response body of login or register with magic link)
    /// - Returns: ``AuthResult`` The AuthResult object contains an authentication token (JWT) and redirect URL. The auth token should be used on all subsequent authenticated requests to the app. The redirect URL specifies the route that users should be redirected to after completed registration or login
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public func getMagicLinkStatus(id: String) async throws -> AuthResult {
        clearTokens()
        let authResult = try await PassageAuth.getMagicLinkStatus(id: id)
        setTokensFromAuthResult(authResult: authResult)
        return authResult
   }
    
    /// This method fetches the current authenticated user
    ///
    /// Will use the authToken from the tokenStore on the instance.
    ///
    /// - Returns: ``PassageUserInfo`` the User object that represents an authenticated user
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public func getCurrentUser() async throws -> PassageUserInfo? {
        
        guard let token = self.tokenStore.authToken else {
            throw PassageError.unauthorized
        }
        
        let currentUser = try await PassageAuth.getCurrentUser(token: token)
        
        return currentUser
    }
    
    
    /// List devices for the current authenticated user. Device information includes the friendly name, ID, when the device was added, and when it was last used.
    ///
    /// Auth Token from the instance tokenStore will be used.
    ///
    /// - Returns: Array of ``DeviceInfo``
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public func listDevices() async throws -> [DeviceInfo] {
        
        guard let token = self.tokenStore.authToken else {
            throw PassageError.unauthorized
        }
        
        let devices = try await PassageAuth.listDevices(token: token)
        
        return devices
    }

    /// Edits the information about the device provided. Currently only the name can be edited.
    ///
    /// Auth Token from the instance tokenStore will be used.
    ///
    /// - Parameters:
    ///   - deviceId: The id of the device to update
    ///   - friendlyName: The new friendly name for the device
    /// - Returns: ``DeviceInfo``
    /// - Throws: ``PassageDeviceError``, ``PassageAPIError``, ``PassageError``
    public func editDevice( deviceId: String, friendlyName: String) async throws -> DeviceInfo? {
        
        guard let token = self.tokenStore.authToken else {
            throw PassageError.unauthorized
        }
        
        let deviceInfo = try await PassageAuth.editDevice(token: token, deviceId: deviceId, friendlyName: friendlyName)
        return deviceInfo
    }
    
    /// Adds the current device for the current authenticated user.
    ///
    /// NOTE: Passkey login is only available for iOS 16+, earlier versions of iOS will send a magic link.
    ///
    /// If Passkeys are supported by the current device the user will be prompted to allow
    ///
    /// Auth Token from the instance tokenStore will be used.
    ///
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageAPIError``, ``PassageError``
    @available(iOS 16.0, *)
    public func addDevice(options: PasskeyCreationOptions? = nil) async throws -> DeviceInfo {
        
        guard let token = self.tokenStore.authToken else {
            throw PassageError.unauthorized
        }
        
        let device = try await PassageAuth.addDevice(token: token, options: options)
        return device
    }

    
    /// Revokes a device for the current authenticated user. The device will no longer be able to log into the Passage account and will need to be re-added.
    ///
    /// Auth Token from the instance tokenStore will be used.
    ///
    /// - Parameters:
    ///   - deviceId: Id of the device to revoke access
    /// - Returns: Void
    /// - Throws: ``PassageDeviceError``, ``PassageAPIError``
    public func revokeDevice( deviceId: String) async throws -> Void {
        guard let token = self.tokenStore.authToken else {
            throw PassageError.unauthorized
        }
        try await PassageAuth.revokeDevice(token: token, deviceId: deviceId)
    }
    
    /// Refreshes the current user's session using the refresh token.
    /// Refresh tokens must be enabled on the current application.
    ///
    /// Refresh Token from the instance tokenStore will be used.
    ///
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public func refresh() async throws -> AuthResult  {
        guard let refreshToken = self.tokenStore.refreshToken else {
            throw PassageError.unauthorized
        }
        let authResult = try await PassageAuth.refresh(refreshToken: refreshToken)
        self.setTokensFromAuthResult(authResult: authResult)
        return authResult
    }
    
    /// Checks validity of the auth token and refreshes the session, if required.
    ///
    /// - Returns: Current authToken
    /// - Throws: ``PassageAPIError``, ``PassageSessionError``
    public func getAuthToken() async throws -> String {
        guard let authToken = self.tokenStore.authToken else {
            throw PassageSessionError.loginRequired
        }
        let refreshToken = self.tokenStore.refreshToken
        let tokens = try await PassageAuth.getAuthToken(authToken: authToken, refreshToken: refreshToken)
        self.tokenStore.authToken = tokens.authToken
        self.tokenStore.refreshToken = tokens.refreshToken
        return tokens.authToken
    }
    
    public func overrideApiUrl(with newUrl: String) {
        PassageSettings.shared.apiUrl = newUrl
    }
    
    // MARK: Instance Private Methods
    
    
    /// Initiates an email change for the currently authenticated user. An email will be sent to the provided email, which they will need to verify before the change takes effect.
    ///
    /// Auth Token from the instance tokenStore will be used.
    ///
    /// - Parameters:
    ///   - newEmail: string - valid email address
    ///   - language: optional language string for localizing emails, if no lanuage or an invalid language is provided the application default lanuage will be used
    /// - Returns: ``MagicLink``
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public func changeEmail(newEmail: String, language: String? = nil) async throws -> MagicLink? {
        guard let token = self.tokenStore.authToken else {
            throw PassageError.unauthorized
        }
        let magicLink = try await PassageAuth.changeEmail(token: token, newEmail: newEmail, language: language)
        return magicLink
    }
    
    /// Initiates a phone number change for the currently authenticated user. A text will be sent to the provided phone number, which they will need to verify before the change takes effect.
    ///
    /// Auth Token from the instance tokenStore will be used.
    ///
    /// - Parameters:
    ///   - newPhone: string - valid E164 formatted phone number.
    ///   - language: optional language string for localizing emails, if no lanuage or an invalid language is provided the application default lanuage will be used
    /// - Returns: ``MagicLink``
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public func changePhone(newPhone: String, language: String? = nil) async throws -> MagicLink? {
        guard let token = self.tokenStore.authToken else {
            throw PassageError.unauthorized
        }
        let magicLink = try await PassageAuth.changePhone(token: token, newPhone: newPhone, language: language)
        return magicLink
    }
    
    
    /// Register a new account
    ///
    ///  This method registers a new account.
    ///
    ///  If an Error occures, the account might already be registered and should login with a passkey
    ///  or a magic link.
    ///
    /// - Parameter identifier: The users email or phone number
    /// - Parameter options: Optional configuration for passkey creation
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageAPIError``,  ``PassageASAuthorizationError``
    @available(iOS 16.0, *)
    public func registerWithPasskey(
        identifier: String,
        options: PasskeyCreationOptions? = nil
    ) async throws -> AuthResult {
        self.clearTokens()
        let authResult = try await PassageAuth
            .registerWithPasskey(identifier: identifier, options: options)
        self.setTokensFromAuthResult(authResult: authResult)
        return authResult
    }
    
    private func clearTokens() -> Void {
        self.tokenStore.clearTokens()
    }
    
    private func setTokensFromAuthResult(authResult: AuthResult) -> Void {
        self.tokenStore.setTokens(authResult: authResult)
    }
    
    
    
    
    // MARK: - Type Public Methods
    
    /// Login a user using a Passkey
    ///
    /// NOTE: Only available on iOS 16+.
    ///
    /// Prompts a user to login to your app using a Passkey. This functions handles the WebAuthn interactions with Passage and the user's browser and device.
    ///
    /// When called will show a list of Passkeys for the user to select from and will
    /// then login with the selected PassKey.
    ///
    /// If the user has no passkeys a PassageLoginError.canceledOrNoPasskey will be thrown.
    ///
    /// This would be a good time to let them enter their identifier and get a login magic link or register
    /// for a new account.
    ///
    /// - Parameter identifier: The user's email, phone number, or other unique id
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageAPIError``,``PassageASAuthorizationError``, ``PassageError``
    @available(iOS 16.0, *)
    public static func loginWithPasskey(identifier: String? = nil) async throws -> AuthResult {
        do {
            let startRequest = LoginWebAuthnStartRequest(identifier: identifier)
            let startResponse = try await LoginAPI
                .loginWebauthnStart(
                    appId: appId,
                    loginWebAuthnStartRequest: startRequest
                )
            guard let credentialAssertion = try await LoginAuthorizationController
                .shared
                .login(from: startResponse)
            else {
                throw PassageASAuthorizationError.credentialRegistration
            }
            let assertionResponse = CredentialAssertionResponseResponse(
                authenticatorData: credentialAssertion.rawAuthenticatorData.toBase64Url(),
                clientDataJSON: credentialAssertion.rawClientDataJSON.toBase64Url(),
                signature: credentialAssertion.signature.toBase64Url(),
                userHandle: credentialAssertion.userID.toBase64Url()
            )
            let credentialId = credentialAssertion.credentialID.toBase64Url()
            let handshakeResponse = CredentialAssertionResponse(
                id: credentialId,
                rawId: credentialId,
                response: assertionResponse,
                type: "public-key"
            )
            let finishRequest = LoginWebAuthnFinishRequest(
                handshakeId: startResponse.handshake.id,
                handshakeResponse: handshakeResponse,
                userId: identifier
            )
            let finishResponse = try await LoginAPI
                .loginWebauthnFinish(
                    appId: appId,
                    loginWebAuthnFinishRequest: finishRequest
                )
            return finishResponse.authResult
        } catch {
            throw error
        }
    }
    
    /// Login by sending the user a magic link.
    ///
    /// - Parameters:
    ///   - identifier: string - email or phone number, depending on your app settings
    ///   - language: optional language string for localizing emails, if no lanuage or an invalid language is provided the application default lanuage will be used
    /// - Returns: ``MagicLink``
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public static func loginWithMagicLink(identifier: String, language: String? = nil) async throws -> MagicLink {
        do {
            let request = LoginMagicLinkRequest(
                identifier: identifier,
                language: language
            )
            let response = try await LoginAPI
                .loginMagicLink(
                    appId: appId,
                    loginMagicLinkRequest: request
                )
            return response.magicLink
        } catch {
            throw error
        }
    }
    
    /// Sign out the current user's session
    ///
    /// - Parameter The user's refresh token
    /// - Returns: Void
    /// - Throws: ``PassageAPIError``
    public static func signOut(refreshToken: String) async throws -> Void {
        do {
            try await TokensAPI
                .revokeRefreshToken(
                    appId: appId,
                    refreshToken: refreshToken
                )
        } catch {
            
        }
    }
    
    
    /// Fetches data about an application, specifically the settings that would affect the way that users register and login.
    ///
    /// - Returns: ``AppInfo``
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public static func appInfo() async throws -> AppInfo {
        do {
            let appInfoResponse = try await AppsAPI.getApp(appId: appId)
            return appInfoResponse.app
        } catch {
            throw error
        }
    }

    /// Get the public details about a user.
    ///
    /// This method gets information about a user (not the currently logged in user) this contains the unauthenticated information about a user, including
    /// their status, user ID, and whether or not they have previously signed in with WebAuthn.
    ///
    /// - Parameter identifier: string - email or phone number, depending on your app settings
    /// - Returns: ``PassageUserInfo`` the unauthenticated information about a user, including their status, user ID, and whether or not they have previously signed in with WebAuthn.
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public static func getUser(identifier: String) async throws -> PassageUserInfo? {
        do {
            let response = try await UsersAPI
                .checkUserIdentifier(
                    appId: appId,
                    identifier: identifier
                )
            guard let user = response.user else {
                return nil
            }
            return PassageUserInfo(
                createdAt: nil,
                email: user.email,
                emailVerified: user.emailVerified,
                id: user.id,
                lastLoginAt: nil,
                loginCount: nil,
                phone: user.phone,
                phoneVerified: user.phoneVerified,
                status: user.status.rawValue,
                socialConnections: nil,
                updatedAt: nil,
                userMetadata: user.userMetadata,
                webauthn: user.webauthn,
                webauthnDevices: nil,
                webauthnTypes: user.webauthnTypes.map { $0.rawValue }
            )
        } catch {
            throw error
        }
    }
    
    /// Checks if the identifier provided exists for the application.
    ///
    /// This method should be used to determine whether to register or log in a user. This method also checks that the app supports the
    /// identifier types (e.g., it will throw an error if a phone number is supplied to an app that only supports emails as an identifier).
    ///
    /// - Parameter identifier: string - email or phone number, depending on your app settings
    /// - Returns: ``Bool``
    public static func identifierExists(identifier: String) async throws -> Bool {
        let user = try await getUser(identifier: identifier)
        return user != nil
    }
    
    /// Creates and send a magic link to register the user. The user will receive an email or text to complete the registration.
    ///
    /// - Parameters:
    ///   - identifier: string - email or phone number, depending on your app settings
    ///   - language: optional language string for localizing emails, if no lanuage or an invalid language is provided the application default lanuage will be used
    /// - Returns: ``MagicLink`` This type include the magic link ID, which can be used to check if the magic link has been activate or not, using the getMagicLinkStatus() method
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public static func newRegisterMagicLink(identifier: String, language: String? = nil) async throws -> MagicLink {
        do {
            let request = RegisterMagicLinkRequest(
                identifier: identifier,
                language: language
            )
            let response = try await RegisterAPI
                .registerMagicLink(
                    appId: appId,
                    user: request
                )
            return response.magicLink
        } catch {
            throw error
        }
    }
    
    /// Creates and send a magic link to login the user. The user will receive an email or text to complete the login.
    /// - Parameters:
    ///   - identifier: string - email or phone number, depending on your app settings
    ///   - language: optional language string for localizing emails, if no lanuage or an invalid language is provided the application default lanuage will be used
    /// - Returns: ``MagicLink`` This type include the magic link ID, which can be used to check if the magic link has been activate or not, using the getMagicLinkStatus() method.
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public static func newLoginMagicLink(identifier: String, language: String? = nil) async throws -> MagicLink {
        do {
            let request = LoginMagicLinkRequest(
                identifier: identifier,
                language: language
            )
            let response = try await LoginAPI
                .loginMagicLink(
                    appId: appId,
                    loginMagicLinkRequest: request
                )
            return response.magicLink
        } catch {
            throw error
        }
    }
    
    /// Completes a magic link login workflow by activating the magic link. The magic link is in the psg_magic_link query parameter when a user clicks the link in their email or text.
    ///
    /// Used to activate either a login or registration magic link.
    ///
    /// - Parameter userMagicLink: string - full magic link that starts with "ml" (sent via email or text to the user)
    /// - Returns: ``AuthResult`` The AuthResult object contains an authentication token (JWT) and redirect URL. The auth token should be used on all subsequent authenticated requests to the app. The redirect URL specifies the route that users should be redirected to after completed registration or login
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public static func magicLinkActivate(userMagicLink: String) async throws -> AuthResult {
        do {
            let request = ActivateMagicLinkRequest(magicLink: userMagicLink)
            let response = try await MagicLinkAPI
                .activateMagicLink(
                    appId: appId,
                    activateMagicLinkRequest: request
                )
            return response.authResult
        } catch {
            throw error
        }
    }
    
    /// Checks the status of a magic link to see if it has been activated.
    ///
    /// This method is usually used for polling.
    ///
    /// - Parameter id: string - ID of the magic link (from response body of login or register with magic link)
    /// - Returns: ``AuthResult`` The AuthResult object contains an authentication token (JWT) and redirect URL. The auth token should be used on all subsequent authenticated requests to the app. The redirect URL specifies the route that users should be redirected to after completed registration or login
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public static func getMagicLinkStatus(id: String) async throws -> AuthResult {
        do {
            let request = GetMagicLinkStatusRequest(id: id)
            let response = try await MagicLinkAPI
                .magicLinkStatus(
                    appId: appId,
                    getMagicLinkStatusRequest: request
                )
            return response.authResult
        } catch {
            throw error
        }
    }
    
    /// Creates and sends a one time passcode to the user. The user will receive an email or text to complete the registration.
    ///
    /// - Parameters:
    ///   - identifier: string - email or phone number, depending on your app settings
    ///   - language: optional language string for localizing emails, if no lanuage or an invalid language is provided the application default lanuage will be used
    /// - Returns: ``OneTimePasscode``
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public static func newRegisterOneTimePasscode(identifier: String, language: String? = nil) async throws -> OneTimePasscode {
        do {
            let request = RegisterOneTimePasscodeRequest(
                identifier: identifier,
                language: language
            )
            let response = try await RegisterAPI
                .registerOneTimePasscode(
                    appId: appId,
                    registerOneTimePasscodeRequest: request
                )
            return OneTimePasscode(id: response.otpId)
        } catch {
            throw error
        }
    }
    
    /// Creates and sends a one time passcode to login the user. The user will receive an email or text to complete the login.
    /// - Parameters:
    ///   - identifier: string - email or phone number, depending on your app settings
    ///   - language: optional language string for localizing emails, if no lanuage or an invalid language is provided the application default lanuage will be used
    /// - Returns: ``OneTimePasscode``
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public static func newLoginOneTimePasscode(identifier: String, language: String? = nil) async throws -> OneTimePasscode {
        do {
            let request = LoginOneTimePasscodeRequest(
                identifier: identifier,
                language: language
            )
            let response = try await LoginAPI
                .loginOneTimePasscode(
                    appId: appId,
                    loginOneTimePasscodeRequest: request
                )
            return OneTimePasscode(id: response.otpId)
        } catch {
            throw error
        }
    }
    
    /// Completes a one time passcode login workflow by activating the one time passcode.
    ///
    /// Used to activate either a login or registration one time passcode.
    ///
    /// - Parameters:
    ///   - otp: The user's one time passcode
    ///   - otpId: The one time passcode id
    /// - Returns: ``AuthResult`` The AuthResult object contains an authentication token (JWT) and redirect URL. The auth token should be used on all subsequent authenticated requests to the app. The redirect URL specifies the route that users should be redirected to after completed registration or login
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public static func oneTimePasscodeActivate(otp: String, otpId: String) async throws -> AuthResult {
        do {
            let request = ActivateOneTimePasscodeRequest(
                otp: otp,
                otpId: otpId
            )
            let response = try await OTPAPI
                .activateOneTimePasscode(
                    appId: appId,
                    activateOneTimePasscodeRequest: request
                )
            return response.authResult
        } catch {
            // TODO: handle exceededAttempts error
            throw error
        }
    }
    
    /// Authorizes user via a supported third-party social provider.
    ///
    /// Using `PassageSocialConnection.apple` connection triggers the native Sign in with Apple UI, while all other connections trigger a secure web view.
    ///
    /// - Parameters:
    ///   - connection: PassageSocialConnection - the Social connection to use for authorization
    ///   - window: UIWindow - the window used as context for presenting the secured web view
    ///   - prefersEphemeralWebBrowserSession: Bool - Set prefersEphemeralWebBrowserSession to true to request that the
    ///   browser doesn’t share cookies or other browsing data between the authentication session and the user’s normal browser session.
    ///   Defaults to false.
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageSocialError``,  ``PassageAPIError``, ``PassageError``
    public static func authorize(
        with connection: PassageSocialConnection,
        in window: UIWindow,
        prefersEphemeralWebBrowserSession: Bool = false
    ) async throws -> AuthResult {
        guard let appInfo = try? await PassageAuth.appInfo() else {
            throw PassageError.invalidAppInfo
        }
        let socialAuthController = PassageSocialAuthController(window: window)
        if connection == .apple {
            let (authCode, idToken) = try await socialAuthController.signInWithApple()
            let request = IdTokenRequest(
                code: authCode,
                idToken: idToken,
                connectionType: .apple
            )
            let response = try await OAuth2API
                .exchangeSocialIdToken(
                    appId: appId,
                    idTokenRequest: request
                )
            return response.authResult
        } else {
            let queryParams = socialAuthController.getSocialAuthQueryParams(
                appId: appInfo.id,
                connection: connection
            )
            guard let authUrl = URL(string: "\(OpenAPIClientAPI.basePath)/apps/\(appId)/\(queryParams)") else {
                throw PassageError.unknown // TODO: update
            }
            let urlScheme = PassageSocialAuthController.getCallbackUrlScheme(appId: appInfo.id)
            let authCode = try await socialAuthController.openSecureWebView(
                url: authUrl,
                callbackURLScheme: urlScheme,
                prefersEphemeralWebBrowserSession: prefersEphemeralWebBrowserSession
            )
            let verifier = socialAuthController.verifier
            let response = try await OAuth2API
                .exchangeSocialToken(
                    appId: appId,
                    code: authCode,
                    verifier: verifier
                )
            return response.authResult
        }
    }
           
    /// This method fetches the user by the specified token.
    /// - Parameter token: an auth token from the AuthResult object
    /// - Returns: ``PassageUserInfo`` the User object that represents an authenticated user
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public static func getCurrentUser(token: String) async throws -> PassageUserInfo {
        setAuthTokenHeader(token: token)
        do {
            let response = try await CurrentuserAPI.getCurrentuser(appId: appId)
            clearAuthTokenHeader()
            let user = response.user
            return PassageUserInfo(
                createdAt: user.createdAt,
                email: user.email,
                emailVerified: user.emailVerified,
                id: user.id,
                lastLoginAt: user.lastLoginAt,
                loginCount: user.loginCount,
                phone: user.phone,
                phoneVerified: user.phoneVerified,
                status: user.status.rawValue,
                socialConnections: user.socialConnections,
                updatedAt: user.updatedAt,
                userMetadata: user.userMetadata,
                webauthn: user.webauthn,
                webauthnDevices: user.webauthnDevices,
                webauthnTypes: user.webauthnTypes.map { $0.rawValue }
            )
        } catch {
            clearAuthTokenHeader()
            throw error
        }
    }
    
    
    /// List devices for the  user. Device information includes the friendly name, ID, when the device was added, and when it was last used.
    ///
    ///  User must be authenticated or the call will throw an error.
    ///
    /// - Returns: Array of ``DeviceInfo``
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public static func listDevices(token: String) async throws -> [DeviceInfo] {
        setAuthTokenHeader(token: token)
        do {
            let response = try await CurrentuserAPI.getCurrentuserDevices(appId: appId)
            clearAuthTokenHeader()
            return response.devices
        } catch {
            clearAuthTokenHeader()
            throw error
        }
    }
    
    
    /// Edits the information about the device provided. Currently only the name can be edited.
    ///
    /// - Parameters:
    ///   - token: The user's auth token
    ///   - deviceId: The id of the device to update
    ///   - friendlyName: The new friendly name for the device
    /// - Returns: ``DeviceInfo``
    /// - Throws: ``PassageDeviceError``, ``PassageAPIError``
    public static func editDevice(
        token: String,
        deviceId: String,
        friendlyName: String
    ) async throws -> DeviceInfo {
        setAuthTokenHeader(token: token)
        do {
            let request = UpdateDeviceRequest(friendlyName: friendlyName)
            let response = try await CurrentuserAPI
                .updateCurrentuserDevice(
                    appId: appId,
                    deviceId: deviceId,
                    updateDeviceRequest: request
                )
            clearAuthTokenHeader()
            return response.device
        } catch {
            clearAuthTokenHeader()
            throw error
        }
    }
    
    /// Adds the current device for the current authenticated user.
    ///
    /// NOTE: Passkey login is only available for iOS 16+, earlier versions of iOS will send a magic link.
    ///
    /// If Passkeys are supported by the current device the user will be prompted to allow
    ///
    /// - Parameter token: The user's auth token
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageAPIError``, ``PassageError``
    @available(iOS 16.0, *)
    public static func addDevice(token: String, options: PasskeyCreationOptions? = nil) async throws -> DeviceInfo {
        setAuthTokenHeader(token: token)
        do {
            let authenticatorAttachment = options?.authenticatorAttachment
            let startRequest = CurrentUserDevicesStartRequest(
                authenticatorAttachment: authenticatorAttachment
            )
            let startResponse = try await CurrentuserAPI
                .postCurrentuserAddDeviceStart(
                    appId: appId,
                    currentUserDevicesStartRequest: startRequest
                )
            let includeSecurityKeyOption = authenticatorAttachment == .any
                || authenticatorAttachment == .crossPlatform
            guard
                let identifier = startResponse.handshake.challenge.publicKey?.user?.name,
                let userId = startResponse.user?.id,
                let credentialCreation = try await RegistrationAuthorizationController
                    .shared
                    .register(
                        from: RegisterWebAuthnStartResponse(
                            handshake: startResponse.handshake,
                            user: startResponse.user
                        ),
                        identifier: identifier,
                        includeSecurityKeyOption: includeSecurityKeyOption
                    )
            else {
                throw PassageError.unknown // TODO: update
            }
            let credentialId = credentialCreation.credentialID.toBase64Url()
            let creationResponse = CredentialCreationResponseResponse(
                attestationObject: credentialCreation.rawAttestationObject?.toBase64Url(),
                clientDataJSON: credentialCreation.rawClientDataJSON.toBase64Url()
            )
            let handshakeResponse = CredentialCreationResponse(
                authenticatorAttachment: authenticatorAttachment?.rawValue,
                id: credentialId,
                rawId: credentialId,
                response: creationResponse,
                type: "public-key"
                )
            let finishRequest = AddDeviceFinishRequest(
                handshakeId: startResponse.handshake.id,
                handshakeResponse: handshakeResponse,
                userId: userId
            )
            let finishResponse = try await CurrentuserAPI
                .postCurrentuserAddDeviceFinish(
                    appId: appId,
                    addDeviceFinishRequest: finishRequest
                )
            clearAuthTokenHeader()
            return finishResponse.device
        } catch {
            clearAuthTokenHeader()
            throw error
        }
    }
    
    /// Revokes a device for the current authenticated user. The device will no longer be able to log into the Passage account and will need to be re-added.
    ///
    /// - Parameters:
    ///   - token: Users auth token
    ///   - deviceId: Id of the device to revoke access
    /// - Returns: Void
    /// - Throws: ``PassageDeviceError``, ``PassageAPIError``
    public static func revokeDevice(token: String, deviceId: String) async throws -> Void {
        setAuthTokenHeader(token: token)
        do {
            try await CurrentuserAPI
                .deleteCurrentuserDevice(
                    appId: appId,
                    deviceId: deviceId
                )
            clearAuthTokenHeader()
        } catch {
            clearAuthTokenHeader()
            throw error
        }
    }
    
    /// Refreshes the current user's session using the refresh token.
    /// Refresh tokens must be enabled on the current application.
    ///
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public static func refresh(refreshToken: String) async throws -> AuthResult {
        do {
            let request = RefreshAuthTokenRequest(refreshToken: refreshToken)
            let response = try await TokensAPI
                .refreshAuthToken(
                    appId: appId,
                    refreshAuthTokenRequest: request
                )
            return response.authResult
        } catch {
            throw error
        }
    }
    
    /// Checks validity of the auth token and refreshes the session, if required.
    ///
    /// - Returns: Current authToken and an optional refresh token, if being used
    /// - Throws: ``PassageAPIError``, ``PassageSessionError``
    public static func getAuthToken(authToken: String, refreshToken: String?) async throws -> (authToken: String, refreshToken: String?){
        let isTokenExpired = PassageTokenUtils(token: authToken).isExpired
        if(!isTokenExpired){
            return (authToken, refreshToken)
        }
        guard let unwrappedRefreshToken = refreshToken else {
            throw PassageSessionError.loginRequired
        }
        var authResult: AuthResult?
        do {
            authResult = try await PassageAuth.refresh(refreshToken: unwrappedRefreshToken)
        } catch PassageAPIError.unauthorized {
            throw PassageSessionError.loginRequired
        } catch {
            throw error
        }
        if let unwrappedAuthResult = authResult {
            return (authToken: unwrappedAuthResult.authToken, refreshToken: unwrappedAuthResult.refreshToken)
        } else {
            throw PassageError.unknown
        }
    }
    
    
    
    
    // MARK: Type Private Methods
    

    
    /// Initiates an email change for the currently authenticated user. An email will be sent to the provided email, which they will need to verify before the change takes effect.
    ///
    /// - Parameters:
    ///   - token: The user's auth token
    ///   - newEmail: string - valid email address
    ///   - language: optional language string for localizing emails, if no lanuage or an invalid language is provided the application default lanuage will be used
    /// - Returns: ``MagicLink``
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public static func changeEmail(token: String, newEmail: String, language: String? = nil) async throws -> MagicLink {
        setAuthTokenHeader(token: token)
        do {
            let request = UpdateUserEmailRequest(language: language, newEmail: newEmail)
            let response = try await CurrentuserAPI
                .updateEmailCurrentuser(
                    appId: appId,
                    updateUserEmailRequest: request
                )
            clearAuthTokenHeader()
            return response.magicLink
        } catch {
            clearAuthTokenHeader()
            throw error
        }
    }
    
    /// Initiates a phone number change for the currently authenticated user. A text will be sent to the provided phone number, which they will need to verify before the change takes effect.
    ///
    /// - Parameters:
    ///   - token: The user's auth token
    ///   - newPhone: string - valid E164 formatted phone number.
    ///   - language: optional language string for localizing emails, if no lanuage or an invalid language is provided the application default lanuage will be used
    /// - Returns: ``MagicLink``
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public static func changePhone(token: String, newPhone: String, language: String? = nil) async throws -> MagicLink {
        setAuthTokenHeader(token: token)
        do {
            let request = UpdateUserPhoneRequest(language: language, newPhone: newPhone)
            let response = try await CurrentuserAPI
                .updatePhoneCurrentuser(
                    appId: appId,
                    updateUserPhoneRequest: request
                )
            clearAuthTokenHeader()
            return response.magicLink
        } catch {
            clearAuthTokenHeader()
            throw error
        }
    }
    
    /// Register a new account
    ///
    ///  This method registers a new account.
    ///
    ///  If an Error occures, the account might already be registered and should login with a passkey
    ///  or a magic link.
    ///
    ///  This method does not check for AppInfo.require_identifier_verification. It should be checked
    ///  prior to this and if true should call sendRegisterMagicLink()
    ///
    ///  This method is private because it could bypass the Passage App Configuration requiring identifiers to be verified.
    ///
    /// - Parameter identifier: The users email or phone number
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageAPIError``,  ``PassageASAuthorizationError``
    @available(iOS 16.0, *)
    public static func registerWithPasskey(
        identifier: String,
        options: PasskeyCreationOptions? = nil
    ) async throws -> AuthResult {
        do {
            let authenticatorAttachment = options?.authenticatorAttachment
            let startRequest = RegisterWebAuthnStartRequest(
                identifier: identifier,
                authenticatorAttachment: authenticatorAttachment ?? .platform
            )
            let startResponse = try await RegisterAPI
                .registerWebauthnStart(
                    appId: appId,
                    registerWebAuthnStartRequest: startRequest
                )
            let includeSecurityKeyOption = authenticatorAttachment == .any
                || authenticatorAttachment == .crossPlatform
            guard
                let credentialCreation = try await RegistrationAuthorizationController
                    .shared
                    .register(
                        from: startResponse,
                        identifier: identifier,
                        includeSecurityKeyOption: includeSecurityKeyOption
                    ),
                  let userId = startResponse.user?.id
            else {
                throw PassageError.unknown // TODO: update
            }
            let credentialId = credentialCreation.credentialID.toBase64Url()
            let creationResponse = CredentialCreationResponseResponse(
                attestationObject: credentialCreation.rawAttestationObject?.toBase64Url(),
                clientDataJSON: credentialCreation.rawClientDataJSON.toBase64Url()
            )
            let handshakeResponse = CredentialCreationResponse(
                authenticatorAttachment: authenticatorAttachment?.rawValue,
                id: credentialId,
                rawId: credentialId,
                response: creationResponse,
                type: "public-key"
                )
            let finishRequest = RegisterWebAuthnFinishRequest(
                handshakeId: startResponse.handshake.id,
                handshakeResponse: handshakeResponse,
                userId: userId
            )
            let finishResponse = try await RegisterAPI
                .registerWebauthnFinish(
                    appId: appId,
                    registerWebAuthnFinishRequest: finishRequest
                )
            return finishResponse.authResult
        } catch {
            throw error
        }
    }
    
    /// Private method to instantiate a logger and log the errors we catch
    ///
    /// - Parameters:
    ///   - error: the Error to log
    ///   - message: An additional message to log before the error log
    /// - Returns: Void
    private static func logError(error: Error, message: String!) -> Void {
        let logger = Logger()
        if (message != nil) {
            logger.error("Error: \(message)")
        }
        logger.error("Error: \(error)")
    }

    
    private static func handlePassageAPIError(error: PassageAPIError) throws -> Void {
        switch error {
        case .badRequest(let errorResponse):
            if let errorResponseBody = errorResponse.body {
                if let errorMessage = errorResponseBody.error {
                    switch errorMessage {
                    case "user: already exists.":
                        throw PassageError.userAlreadyExists
                    case "user does not exist":
                        throw PassageError.userDoesNotExist
                    default:
                        throw error
                    }

                }
            }
            throw error
        case .notFound(let errorResponse):
            if let errorResponseBody = errorResponse.body {
                if let errorMessage = errorResponseBody.error {
                    switch errorMessage {
                    case "user does not exist":
                        throw PassageError.userDoesNotExist
                    default:
                        throw error
                    }
                }
            }
            throw error
        default:
            throw error
        }
        
    }
    
    private static func setAuthTokenHeader(token: String) {
        OpenAPIClientAPI.customHeaders["Authorization"] = "Bearer \(token)"
    }
    
    private static func clearAuthTokenHeader() {
        OpenAPIClientAPI.customHeaders["Authorization"] = ""
    }
    
    // MARK AutoFill Methods - WIP
    
    /// Start the autofill job
    ///
    /// Currently a work in progress, so not public
    ///
    /// - Returns: <#description#>
    @available(iOS 16.0, *)
    internal static func autoFillStart() async throws -> LoginWebAuthnStartResponse {

        // should check error status if code == 404 throw userNotFound
        let loginStartResponse = try await LoginAPI.loginWebauthnStart(appId: appId)

        return loginStartResponse
    }

    
    /// Finish an autofill request
    ///
    /// Currently a work in progress, so not public
    ///
    /// - Parameters:
    ///   - startResponse: The ``WebuathnLoginStartResponse`` from the autoFillStart call
    ///   - credentialAssertion: The credential assertion from the ASAuthorizationController
    /// - Returns: ``AuthResult``
    @available(iOS 16.0, *)
    internal static func autoFillFinish(
        startResponse: LoginWebAuthnStartResponse,
        credentialAssertion: ASAuthorizationPlatformPublicKeyCredentialAssertion
    ) async throws -> AuthResult {
        do {
            let assertionResponse = CredentialAssertionResponseResponse(
                authenticatorData: credentialAssertion.rawAuthenticatorData.toBase64Url(),
                clientDataJSON: credentialAssertion.rawClientDataJSON.toBase64Url(),
                signature: credentialAssertion.signature.toBase64Url(),
                userHandle: credentialAssertion.userID.toBase64Url()
            )
            let credentialId = credentialAssertion.credentialID.toBase64Url()
            let handshakeResponse = CredentialAssertionResponse(
                id: credentialId,
                rawId: credentialId,
                response: assertionResponse,
                type: "public-key"
            )
            let request = LoginWebAuthnFinishRequest(
                handshakeId: startResponse.handshake.id,
                handshakeResponse: handshakeResponse,
                userId: startResponse.user?.id
            )
            let response = try await LoginAPI
                .loginWebauthnFinish(
                    appId: appId,
                    loginWebAuthnFinishRequest: request
                )
            return response.authResult
        } catch {
            throw error
        }
    }
    
    /// Start the Passkey Autofill Service
    ///
    /// You should call this as early in your View lifecycle as possible. Make sure your input field has it's textContentType set to username.
    ///
    /// - Parameters:
    ///   - anchor: Usually set to Window on your View.
    ///   - onSuccess: function to run on successful Passkey login, this method should update the UI to a logged in state
    ///   - onError: function to run if an error occures on Passkey login.
    ///   - onCancel: function to run if the user cancels the Passkey login
    /// - Returns: Void
    @available(iOS 16.0, *)
    public static func beginAutoFill(anchor: ASPresentationAnchor, onSuccess:  ((AuthResult) -> Void)?, onError: ((Error) -> Void)?, onCancel: (() -> Void)?) async throws -> Void {
        try await PassageAutofillAuthorizationController.shared.begin(anchor: anchor, onSuccess: onSuccess, onError: onError, onCancel: onCancel)
    }

}



extension String {
    func decodeBase64Url() -> Data? {
        var base64 = self
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        if base64.count % 4 != 0 {
            base64.append(String(repeating: "=", count: 4 - base64.count % 4))
        }
        return Data(base64Encoded: base64)
    }
}
extension Data {
    func toBase64Url() -> String {
        return self.base64EncodedString().replacingOccurrences(of: "+", with: "-").replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: "=", with: "")
    }
}
