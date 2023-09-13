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
    
    // MARK: Instance Public Methods
    

    /// Register a new user using a Passkey or a fallback method, and manage the tokens.
    ///
    /// If the user is authenticated and not sent a magic link or one time passcode, the tokens will be stored in the tokenStore
    /// on the instance.
    ///
    /// Note: Passkey registration is only available for iOS 16+, earlier versions of iOS will send a
    /// registration magic link or one time passcode.
    ///
    /// If your Passage application is configured to not allow public signups this method will throw
    /// a ``PassageRegisterError``.publicRegistrationDisabled.
    ///
    /// If your Passage application is configured to require identifier verification then Passkeys will not be used and a magic link
    /// or a one time passcode will be sent and the user will have to verify their identifier before being authenticated.
    ///
    /// Returns a tuple (authResult: ``AuthResult``?, authFallbackResult: ``AuthFallbackResult``?)
    ///
    /// If an authResult is returned the user was registered and logged in. If an authFallbackResult is returned the user was sent a magic link
    /// or one time passcode, and if neither are returned, then the user was not registered and no fallback method was used.
    ///
    /// - Parameters:
    ///   - identifier: string - email or phone number, depending on your app settings
    /// - Returns:  (authResult: ``AuthResult``?, authFallbackResult: ``AuthFallbackResult``?)
    public func register(identifier: String) async throws -> (authResult: AuthResult?, authFallbackResult: AuthFallbackResult?) {
        clearTokens()
        let result = try await PassageAuth.register(identifier: identifier)
        if let authResult = result.authResult {
            setTokensFromAuthResult(authResult: authResult)
        }
        return result
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
    
    /// Login a user with either a Passkey or use a fallback method.
    ///
    /// If the user is authenticated and not sent a magic link or one time passcode, the tokens will be stored in the tokenStore
    /// on the instance.
    ///
    /// NOTE: Passkey login is only available for iOS 16+, earlier versions of iOS will send magic link or one time passcode.
    ///
    /// iOS 16+
    /// On iOS 16+ this method will prompt a user to login to your app using a Passkey. This function handles the
    /// WebAuthN interactions with Passage the the user's device.
    ///
    /// If the user does not have a Passkey or they cancel the Passkey prompt and an identifer is passed in
    /// a magic link will be sent.
    ///
    /// iOS 14 and 15
    ///
    /// This method will send a magic link or one time passcode to the user (either email or text depending on identifier).
    ///
    /// Returns a tuple (authResult: ``AuthResult``?, authFallbackResult: ``AuthFallbackResult``?)
    ///
    /// If an authResult is returned the user was logged in.  If an authFallbackResult is returned the user was sent a magic link or a one time passcode,
    /// and if neither are returned, then the user was not logged in and no fallback method was used.
    ///
    /// - Parameters:
    ///   - identifier: string - email or phone number, depending on your app settings
    /// - Returns:  (authResult: ``AuthResult``?, authFallbackResult: ``AuthFallbackResult``?)
    /// - Throws: ``PasageLoginError``, ``PassageAPIError``, ``PassageError``
    public func login(identifier: String) async throws -> (authResult: AuthResult?, authFallbackResult: AuthFallbackResult?) {
        clearTokens()
        let result = try await PassageAuth.login(identifier: identifier)
        if let authResult = result.authResult {
            setTokensFromAuthResult(authResult: authResult)
        }
        return result
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
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageAPIError``,``PassageASAuthorizationError``, ``PassageError``
    @available(iOS 16.0, *)
    public func loginWithPasskey() async throws -> AuthResult {
        self.clearTokens()
        let authResult = try await PassageAuth.loginWithPasskey()
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
    public func addDevice() async throws -> DeviceInfo {
        
        guard let token = self.tokenStore.authToken else {
            throw PassageError.unauthorized
        }
        
        let device = try await PassageAuth.addDevice(token: token)
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
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageAPIError``,  ``PassageASAuthorizationError``
    @available(iOS 16.0, *)
    public func registerWithPasskey(identifier: String) async throws -> AuthResult {
        self.clearTokens()
        let authResult = try await PassageAuth.registerWithPasskey(identifier: identifier)
        self.setTokensFromAuthResult(authResult: authResult)
        return authResult
    }
    
    /// Login a user by their identifier (Not supported at this time)
    ///
    /// This method is currently not supported in iOS
    /// Currently only passkey login is supported. Does not use passkey.
    /// - Parameter identifier: <#identifier description#>
    /// - Returns: <#description#>
    /// - Throws: ``PassageAPIError``,``PassageASAuthorizationError``, ``PassageError``
    @available(iOS 16.0, *)
    private func loginWithIdentifier(identifier: String) async throws -> AuthResult {
        self.clearTokens()
        let authResult = try await PassageAuth.loginWithIdentifier(identifier: identifier)
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
    
    /// Register a new user using a Passkey or a fallback method
    ///
    /// Note: Passkey registration is only available for iOS 16+, earlier versions of iOS will send a
    /// registration magic link or one time passcode.
    ///
    /// If your Passage application is configured to not allow public signups this method will throw
    /// a ``PassageRegisterError``.publicRegistrationDisabled.
    ///
    /// If your Passage application is configured to require identifier verification then Passkeys will not be used and a magic link
    /// or a one time passcode will be sent and the user will have to verify their identifier before being authenticated.
    ///
    /// Returns a tuple (authResult: ``AuthResult``?, authFallbackResult: ``AuthFallbackResult``?)
    ///
    /// If an authResult is returned the user was registered and logged in.  If an authFallbackResult is returned the user was sent a magic link
    /// or one time passcode, and if neither are returned, then the user was not registered and no fallback method was used.
    ///
    /// - Parameters:
    ///   - identifier: string - email or phone number, depending on your app settings
    /// - Returns:  (authResult: ``AuthResult``?, magicLink: ``MagicLink``?)
    /// - Throws: ``PassageError``, ``PassageAPIError``
    public static func register(identifier: String) async throws -> (authResult: AuthResult?, authFallbackResult: AuthFallbackResult?) {
        guard let appInfo = try? await PassageAuth.appInfo() else {
            throw PassageError.invalidAppInfo
        }
        guard appInfo.publicSignup else {
            throw PassageRegisterError.publicRegistrationDisabled
        }
        let useFallback = appInfo.requireIdentifierVerification
        guard !useFallback, #available(iOS 16.0, *) else {
            guard let fallbackMethod = appInfo.authFallbackMethod else {
                throw PassageError.invalidAuthFallbackMethod
            }
            var authFallbackResult: AuthFallbackResult? = nil
            switch fallbackMethod {
            case .magicLink:
                authFallbackResult = try await PassageAuth.newRegisterMagicLink(identifier: identifier)
            case .oneTimePasscode:
                authFallbackResult = try await PassageAuth.newRegisterOneTimePasscode(identifier: identifier)
            case .none:
                throw PassageError.authFallbacksNotSupported
            }
            return (nil, authFallbackResult)
        }
        let authResult = try await PassageAuth.registerWithPasskey(identifier: identifier)
        return (authResult, nil)
    }
    
    /// Login a user with either a Passkey or use a fallback method.
    ///
    /// NOTE: Passkey login is only available for iOS 16+, earlier versions of iOS will send magic link or one time passcode.
    ///
    /// iOS 16+
    /// On iOS 16+ this method will prompt a user to login to your app using a Passkey. This function handles the
    /// WebAuthN interactions with Passage the the user's device.
    ///
    /// If the user does not have a Passkey or they cancel the Passkey prompt and an identifer is passed in
    /// a magic link will be sent.
    ///
    /// iOS 14 and 15
    ///
    /// This method will send a magic link or one time passcode to the user (either email or text depending on identifier).
    ///
    /// Returns a tuple (authResult: ``AuthResult``?, authFallbackResult: ``AuthFallbackResult``?)
    ///
    /// If an authResult is returned the user was logged in.  If an authFallbackResult is returned the user was sent a magic link or a one time passcode,
    /// and if neither are returned, then the user was not logged in and no fallback method was used.
    ///
    /// - Parameters:
    ///   - identifier: string - email or phone number, depending on your app settings
    /// - Returns:  (authResult: ``AuthResult``?, authFallbackResult: ``AuthFallbackResult``?)
    /// - Throws: ``PasageLoginError``, ``PassageAPIError``, ``PassageError``
    public static func login(identifier: String) async throws  -> (authResult: AuthResult?, authFallbackResult: AuthFallbackResult?) {
        guard (try? await PassageAuth.identifierExists(identifier: identifier)) == true else {
            throw PassageError.userDoesNotExist
        }
        if #available(iOS 16.0, *), let authResult = try? await PassageAuth.loginWithPasskey() {
            return (authResult, nil)
        }
        guard let appInfo = try? await PassageAuth.appInfo() else {
            throw PassageError.invalidAppInfo
        }
        guard let fallbackMethod = appInfo.authFallbackMethod else {
            throw PassageError.invalidAuthFallbackMethod
        }
        var authFallbackResult: AuthFallbackResult? = nil
        switch fallbackMethod {
        case .magicLink:
            authFallbackResult = try await newLoginMagicLink(identifier: identifier)
        case .oneTimePasscode:
            authFallbackResult = try await newLoginOneTimePasscode(identifier: identifier)
        case .none:
            throw PassageError.authFallbacksNotSupported
        }
        return (nil, authFallbackResult)
    }
    
    
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
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageAPIError``,``PassageASAuthorizationError``, ``PassageError``
    @available(iOS 16.0, *)
    public static func loginWithPasskey() async throws -> AuthResult {
        
        var authResult : AuthResult?
        do {
            let loginWithIdentifierStartResponse = try await PassageAPIClient.shared.webauthnLoginStart()
            
            let credentialAssertion = try await LoginAuthorizationController.shared.login(from: loginWithIdentifierStartResponse)
            
            authResult = try await PassageAPIClient.shared.webauthnLoginFinish(startResponse: loginWithIdentifierStartResponse, credentialAssertion: credentialAssertion)
        } catch (let error as PassageAPIError) {
            try PassageAuth.handlePassageAPIError(error: error)
        } catch {
            throw error
        }
            
        if let unwrappedAuthResult = authResult {
            return unwrappedAuthResult
        } else {
            throw PassageError.unknown
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
        var magicLink: MagicLink?
        do {
            magicLink = try await PassageAuth.newLoginMagicLink(identifier: identifier, language: language)
        } catch (let error as PassageAPIError) {
            try PassageAuth.handlePassageAPIError(error: error)
        } catch {
            throw error
        }
        
        if let unwrappedMagicLink = magicLink {
            return unwrappedMagicLink
        } else {
            throw PassageError.unknown
        }
    }
    
    /// Sign out the current user's session
    ///
    /// - Parameter The user's refresh token
    /// - Returns: Void
    /// - Throws: ``PassageAPIError``
    public static func signOut(refreshToken: String) async throws -> Void {
        do {
            try await PassageAPIClient.shared.signOut(refreshToken: refreshToken)
        } catch (let error as PassageAPIError) {
            try PassageAuth.handlePassageAPIError(error: error)
        } catch {
            throw error
        }
    }
    
    
    /// Fetches data about an application, specifically the settings that would affect the way that users register and login.
    ///
    /// - Returns: ``AppInfo``
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public static func appInfo() async throws -> AppInfo? {
        
        var appInfo: AppInfo?
        
        do {
            appInfo = try await PassageAPIClient.shared.appInfo()
        } catch (let error as PassageAPIError) {
            try PassageAuth.handlePassageAPIError(error: error)
        } catch {
            throw PassageError.unknown
        }
        
        return appInfo
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
            let user = try await PassageAPIClient.shared.getUser(identifier: identifier)
            return user
        } catch (let error as PassageAPIError) {
            try PassageAuth.handlePassageAPIError(error: error)
            throw error
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
    /// - Returns: ``PassageUserInfo`` This contains the unauthenticated information about a user, including their status, user ID, and whether or not they have previously signed in with WebAuthn.
    public static func identifierExists(identifier: String) async throws -> Bool {
        
        var user: PassageUserInfo?
        do {
            user = try await PassageAuth.getUser(identifier: identifier)
        } catch {
            user = nil
        }

        return (user != nil) ? true : false
    }
    
    /// Creates and send a magic link to register the user. The user will receive an email or text to complete the registration.
    ///
    /// - Parameters:
    ///   - identifier: string - email or phone number, depending on your app settings
    ///   - language: optional language string for localizing emails, if no lanuage or an invalid language is provided the application default lanuage will be used
    /// - Returns: ``MagicLink`` This type include the magic link ID, which can be used to check if the magic link has been activate or not, using the getMagicLinkStatus() method
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public static func newRegisterMagicLink(identifier: String, language: String? = nil) async throws -> MagicLink {
        var magicLink: MagicLink?
        do {
            magicLink = try await PassageAPIClient.shared.sendRegisterMagicLink(identifier: identifier, path: nil, language: language)
        } catch (let error as PassageAPIError) {
            try PassageAuth.handlePassageAPIError(error: error)
        } catch {
            throw error
        }
        
        if let unwrappedMagicLink = magicLink {
            return unwrappedMagicLink
        } else {
            throw PassageError.unknown
        }
    }
    
    /// Creates and send a magic link to login the user. The user will receive an email or text to complete the login.
    /// - Parameters:
    ///   - identifier: string - email or phone number, depending on your app settings
    ///   - language: optional language string for localizing emails, if no lanuage or an invalid language is provided the application default lanuage will be used
    /// - Returns: ``MagicLink`` This type include the magic link ID, which can be used to check if the magic link has been activate or not, using the getMagicLinkStatus() method.
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public static func newLoginMagicLink(identifier: String, language: String? = nil) async throws -> MagicLink {
        var magicLink: MagicLink?
        do {
            magicLink = try await PassageAPIClient.shared.sendLoginMagicLink(identifier: identifier, path: nil, language: language)
        } catch (let error as PassageAPIError) {
            try PassageAuth.handlePassageAPIError(error: error)
        } catch {
            throw error
        }
        if let unwrappedMagicLink = magicLink {
            return unwrappedMagicLink
        } else {
            throw PassageError.unknown
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
        var authResult: AuthResult?
        do {
            authResult = try await PassageAPIClient.shared.activateMagicLink(magicLink: userMagicLink)
        } catch (let error as PassageAPIError) {
            try PassageAuth.handlePassageAPIError(error: error)
        } catch {
            throw error
        }
        if let unwrappedAuthResult = authResult {
            return unwrappedAuthResult
        } else {
            throw PassageError.unknown
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
        var authResult: AuthResult?
        do {
            authResult = try await PassageAPIClient.shared.magicLinkStatus(id: id)
        } catch (let error as PassageAPIError) {
            try PassageAuth.handlePassageAPIError(error: error)
        } catch {
            throw error
        }
        if let unwrappedAuthResult = authResult {
            return unwrappedAuthResult
        } else {
            throw PassageError.unknown
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
            let oneTimePasscode = try await PassageAPIClient.shared.sendRegisterOneTimePasscode(identifier: identifier, language: language)
            return oneTimePasscode
        } catch {
            if let error = error as? PassageAPIError {
                try PassageAuth.handlePassageAPIError(error: error)
            }
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
            let oneTimePasscode = try await PassageAPIClient.shared.sendLoginOneTimePasscode(identifier: identifier, language: language)
            return oneTimePasscode
        } catch {
            if let error = error as? PassageAPIError {
                try PassageAuth.handlePassageAPIError(error: error)
            }
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
            let authResult = try await PassageAPIClient.shared.activateOneTimePasscode(otp: otp, otpId: otpId)
            return authResult
        } catch {
            if let error = error as? PassageAPIError {
                try PassageAuth.handlePassageAPIError(error: error)
            }
            throw error
        }
    }
    
           
    /// This method fetches the user by the specified token.
    /// - Parameter token: an auth token from the AuthResult object
    /// - Returns: ``PassageUserInfo`` the User object that represents an authenticated user
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public static func getCurrentUser(token: String) async throws -> PassageUserInfo? {
        var user: PassageUserInfo?
        do {
            user = try await PassageAPIClient.shared.currentUser(token: token)
        } catch (let error as PassageAPIError) {
            try PassageAuth.handlePassageAPIError(error: error)
        } catch {
            throw error
        }
        return user
    }
    
    
    /// List devices for the  user. Device information includes the friendly name, ID, when the device was added, and when it was last used.
    ///
    ///  User must be authenticated or the call will throw an error.
    ///
    /// - Returns: Array of ``DeviceInfo``
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public static func listDevices(token: String) async throws -> [DeviceInfo] {
        var devices: [DeviceInfo]?
        do {
            devices = try await PassageAPIClient.shared.listDevices(token: token)
        } catch (let error as PassageAPIError) {
            try PassageAuth.handlePassageAPIError(error: error)
        } catch {
            throw error
        }
        if let unwrappedDevices = devices {
            return unwrappedDevices
        } else {
            return []
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
    public static func editDevice(token: String, deviceId: String, friendlyName: String) async throws -> DeviceInfo? {
        var deviceInfo: DeviceInfo?
        do {
            deviceInfo = try await PassageAPIClient.shared.updateDevice(token: token, deviceId: deviceId, friendlyName: friendlyName)
        }
        catch PassageAPIError.notFound {
            throw PassageDeviceError.notFound
        } catch (let error as PassageAPIError) {
            try PassageAuth.handlePassageAPIError(error: error)
        } catch  {
            throw error
        }
        return deviceInfo
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
    public static func addDevice(token: String) async throws -> DeviceInfo {
        do {
            let startResponse = try await PassageAPIClient.shared.addDeviceStart(token: token)
            guard let registrationRequest = try await RegistrationAuthorizationController.shared
                .register(from: startResponse, identifier: startResponse.handshake.challenge.publicKey.user.name )
            else {
                throw PassageError.unknown
            }
            let device = try await PassageAPIClient.shared
                .addDeviceFinish(token: token, startResponse: startResponse, params: registrationRequest)
            return device
        }  catch {
            if let apiError = error as? PassageAPIError {
                try PassageAuth.handlePassageAPIError(error: apiError)
            }
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
        do {
            try await PassageAPIClient.shared.revokeDevice(token: token, deviceId: deviceId)
        } catch PassageAPIError.notFound {
            throw PassageDeviceError.notFound
        } catch (let error as PassageAPIError) {
            try PassageAuth.handlePassageAPIError(error: error)
        } catch {
            throw error
        }
    }
    
    /// Refreshes the current user's session using the refresh token.
    /// Refresh tokens must be enabled on the current application.
    ///
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageAPIError``, ``PassageError``
    public static func refresh(refreshToken: String) async throws -> AuthResult {
        var authResult: AuthResult?
        do {
            authResult = try await PassageAPIClient.shared.refresh(refreshToken: refreshToken)
        } catch (let error as PassageAPIError) {
            try PassageAuth.handlePassageAPIError(error: error)
        } catch {
            throw error
        }
        if let unwrappedAuthResult = authResult {
            return unwrappedAuthResult
        } else {
            throw PassageError.unknown
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
        do {
            let magicLink = try await PassageAPIClient.shared
                .changeEmail(token: token, newEmail: newEmail, magicLinkPath: nil, redirectUrl: nil, language: language)
            return magicLink
        } catch {
            if let apiError = error as? PassageAPIError {
                try PassageAuth.handlePassageAPIError(error: apiError)
            }
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
        do {
            let magicLink = try await PassageAPIClient.shared
                .changePhone(token: token, newPhone: newPhone, magicLinkPath: nil, redirectUrl: nil, language: language)
            return magicLink
        } catch {
            if let apiError = error as? PassageAPIError {
                try PassageAuth.handlePassageAPIError(error: apiError)
            }
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
    private static func registerWithPasskey(identifier: String) async throws -> AuthResult {
        var authResult: AuthResult?
        do {
            let registrationStartResponse = try await PassageAPIClient.shared.webauthnRegistrationStart(identifier: identifier)
            
            let registrationRequest = try await RegistrationAuthorizationController.shared.register(from: registrationStartResponse, identifier: identifier)
            
            authResult = try await PassageAPIClient.shared.webauthnRegistrationFinish(startResponse: registrationStartResponse, params: registrationRequest)
        } catch (let error as PassageAPIError) {
            try PassageAuth.handlePassageAPIError(error: error)
        } catch  {
            throw error
        }
        
        if let unwrappedAuthResult = authResult {
            return unwrappedAuthResult
        } else {
            throw PassageError.unknown
        }

    }
    
    /// Login a user by their identifier (Not supported at this time)
    ///
    /// This method is currently not supported in iOS
    /// Currently only passkey login is supported. Does not use passkey.
    /// - Parameter identifier: <#identifier description#>
    /// - Returns: <#description#>
    /// - Throws: ``PassageAPIError``,``PassageASAuthorizationError``, ``PassageError``
    @available(iOS 16.0, *)
    private static func loginWithIdentifier(identifier: String) async throws -> AuthResult {
        var authResult: AuthResult?
        do {
            // if error status code of 404 userNotFound
            let loginWithIdentifierStartResponse = try await PassageAPIClient.shared.webauthnLoginWithIdentifierStart(identifier: identifier )
            
            let credentialAssertion = try await LoginAuthorizationController.shared.loginWithIdentifier(from: loginWithIdentifierStartResponse, identifier: identifier)
            
            authResult = try await PassageAPIClient.shared.webauthnLoginWithIdentifierFinish(startResponse: loginWithIdentifierStartResponse, credentialAssertion: credentialAssertion)
        } catch (let error as PassageAPIError) {
            try PassageAuth.handlePassageAPIError(error: error)
        }
        catch {
            throw error
        }
        
        if let unwrappedAuthResult = authResult {
            return unwrappedAuthResult
        } else {
            throw PassageError.unknown
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
    
    // MARK AutoFill Methods - WIP
    
    /// Start the autofill job
    ///
    /// Currently a work in progress, so not public
    ///
    /// - Returns: <#description#>
    @available(iOS 16.0, *)
    internal static func autoFillStart() async throws -> WebauthnLoginStartResponse {

        // should check error status if code == 404 throw userNotFound
        let loginStartResponse = try await PassageAPIClient.shared.webauthnLoginStart()

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
    internal static func autoFillFinish(startResponse: WebauthnLoginStartResponse, credentialAssertion: ASAuthorizationPlatformPublicKeyCredentialAssertion) async throws -> AuthResult {

        var authResult: AuthResult!

        do {
            authResult = try await PassageAPIClient.shared.webauthnLoginFinish(startResponse: startResponse, credentialAssertion: credentialAssertion)
        }
        catch {
            throw error
        }

        return authResult

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
