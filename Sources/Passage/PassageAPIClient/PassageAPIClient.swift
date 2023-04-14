import AuthenticationServices
import os

/// Passage API Client
///
/// Implements all the network requests to the Passage API's 
internal class PassageAPIClient : PassageAuthAPIClient {
    
    private enum RequestMethod: String {
        case get = "GET"
        case patch = "PATCH"
        case post = "POST"
    }

    /// Singleton instance of the PassageAPIClient
    ///
    /// Get the shared instance of the PassageAPIClient. The PassageAPIClient implements a singleton pattern
    /// and cannot be directly instantiated. Use the shared instance to make all network requests.
    internal static var shared: PassageAuthAPIClient = PassageAPIClient()
    
    /// The Passage AppId
    ///
    /// This should be configured in the Passage.plist file. The value can be found in the Passage Console
    internal var appId: String?
    
    /// The url of the Passage API server.
    ///
    /// This should be set in the Passage.plist file or it will default to the production url
    internal var baseUrl: String?
    
    
    /// Private initializer
    ///
    /// PassageAPIClient cannot be instantiated directly, use the shared prop to make network requeists.
    ///
    /// This initializer will read the appId and baseURl from the Passage.plist file.
    private init() {
        self.appId = PassageSettings.shared.appId!
        self.baseUrl = PassageSettings.shared.apiUrl ?? "https://auth.passage.id"
    }

    /// Get the configured Passage Application details.
    /// - Returns: ``AppInfo``
    /// - Throws: ``PassageAPIError``,
    internal func appInfo() async throws -> AppInfo {
        let url = try self.appUrl(path: "")
        
        let request = buildRequest(url: url, method: "GET")
        
        let (responseData, response) = try await URLSession.shared.data(for: request)
        
        try assertValidResponse(response: response, responseData: responseData)

        let appInfoResponse = try JSONDecoder().decode(AppInfoResponse.self, from: responseData)
        
        return appInfoResponse.app
    }
    
    /// Perform a webauthn login start request
    /// - Returns: ``WebauthnLoginStartResponse``
    /// - Throws: ``PassageAPIError``
    @available(iOS 16.0, *)
    internal func webauthnLoginStart() async throws -> WebauthnLoginStartResponse {
        
        let url = try self.appUrl(path: "login/webauthn/start/")
        
        let request = buildRequest(url: url, method: "POST")
        
        let (responseData, response) = try await URLSession.shared.data(for: request)

        // validate the response
        // calling code should check status, if status code 404 throw userNotFound
        try assertValidResponse(response: response, responseData: responseData)

        let loginResponse = try JSONDecoder().decode(WebauthnLoginStartResponse.self, from: responseData)
        
        return loginResponse

    }
    
    /// Perform a webauthn login finish request to complete an authentication attempt
    /// - Parameters:
    ///   - startResponse: ``WebauthnLoginStartResponse`` from the previous login start request
    ///   - credentialAssertion: ``ASAuthorizationPlatformPublicKeyCredentialAssertion``
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageAPIError``
    @available(iOS 16.0, *)
    internal func webauthnLoginFinish(startResponse: WebauthnLoginStartResponse, credentialAssertion: ASAuthorizationPlatformPublicKeyCredentialAssertion?) async throws -> AuthResult {
        guard let credentialAssertion else {
            throw PassageASAuthorizationError.credentialRegistration
        }
        
        let url = try self.appUrl(path: "login/webauthn/finish/")

        let response = [
            "clientDataJSON": credentialAssertion.rawClientDataJSON.toBase64Url(),
            "authenticatorData": credentialAssertion.rawAuthenticatorData.toBase64Url(),
            "signature": credentialAssertion.signature.toBase64Url(),
            "userHandle": credentialAssertion.userID.toBase64Url()
        ]
        let credId = credentialAssertion.credentialID.toBase64Url();
        let handshakeResponse = [
            "rawId": credId,
            "id": credId,
            "type": "public-key",
            "response": response
        ] as [String : Any]
        let parameters = [
            "handshake_id": startResponse.handshake.id,
            "handshake_response": handshakeResponse,
        ] as [String : Any]
        
        let request = buildRequest(url: url, method: "POST")

        
        let data = try JSONSerialization.data(withJSONObject: parameters, options: [])


        let (responseData, resp) = try await URLSession.shared.upload(for: request, from: data)
        
        try assertValidResponse(response: resp, responseData: responseData)
        
        let authResponse = try JSONDecoder().decode(WebauthnLoginFinishResponse.self, from: responseData)

        return authResponse.authResult
    }
    
    /// Peform a webauthn login start request for the specified identifier
    /// - Parameter identifier: Email address or phone number
    /// - Returns: ``WebauthnLoginStartResponse``
    /// - Throws: ``PassageAPIError``
    @available(iOS 16.0, *)
    internal func webauthnLoginWithIdentifierStart(identifier: String) async throws -> WebauthnLoginStartResponse {
        
        let url = try self.appUrl(path: "login/webauthn/start/")
        
        let request = buildRequest(url: url, method: "POST")

        let data = try JSONSerialization.data(withJSONObject: ["identifier": identifier], options: [])
               
        let (responseData, response) = try await URLSession.shared.upload(for: request, from: data)

        try assertValidResponse(response: response, responseData: responseData)

        let loginResponse = try JSONDecoder().decode(WebauthnLoginStartResponse.self, from: responseData)
        
        return loginResponse

    }
    
    /// Perform a webauthn login finish request to complete an authentication attempt
    /// - Parameters:
    ///   - startResponse: ``WebauthnLoginStartResponse`` from the previous login start request
    ///   - credentialAssertion: ``ASAuthorizationPlatformPublicKeyCredentialAssertion``
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageAPIError``
    @available(iOS 16.0, *)
    internal func webauthnLoginWithIdentifierFinish(startResponse: WebauthnLoginStartResponse, credentialAssertion: ASAuthorizationPlatformPublicKeyCredentialAssertion) async throws -> AuthResult {
        let url = try self.appUrl(path: "login/webauthn/finish/")
        
        let response = [
            "clientDataJSON": credentialAssertion.rawClientDataJSON.toBase64Url(),
            "authenticatorData": credentialAssertion.rawAuthenticatorData.toBase64Url(),
            "signature": credentialAssertion.signature.toBase64Url(),
            "userHandle": credentialAssertion.userID.toBase64Url()
        ]
        let credId = credentialAssertion.credentialID.toBase64Url();
        let handshakeResponse = [
            "rawId": credId,
            "id": credId,
            "type": "public-key",
            "response": response
        ] as [String : Any]
        let parameters = [
            "user_id" : startResponse.user!.id,
            "handshake_id": startResponse.handshake.id,
            "handshake_response": handshakeResponse,
        ] as [String : Any]
        
        let request = buildRequest(url: url, method: "POST")
        
        let data = try JSONSerialization.data(withJSONObject: parameters, options: [])

        let (responseData, resp) = try await URLSession.shared.upload(for: request, from: data)
        
        try assertValidResponse(response: resp, responseData: responseData)
        
        let authResponse = try JSONDecoder().decode(WebauthnLoginFinishResponse.self, from: responseData)

        return authResponse.authResult
        
    }


    /// Perform a webauthn registration start request
    /// - Parameter identifier: The users identifier (email or phone number)
    /// - Returns: ``WebauthnRegisterStartResponse``
    /// - Throws: ``PassageAPIError``
    @available(iOS 16.0, *)
    internal func webauthnRegistrationStart(identifier: String) async throws -> WebauthnRegisterStartResponse {
        let url = try self.appUrl(path: "register/webauthn/start/")
        
        let request = buildRequest(url: url, method: "POST")

        let data = try JSONSerialization.data(withJSONObject: ["identifier": identifier], options: [])
        
        let (responseData, response) = try await URLSession.shared.upload(for: request, from: data)
        
        try assertValidResponse(response: response, responseData: responseData)
        
        let registrationResponse = try JSONDecoder().decode(WebauthnRegisterStartResponse.self, from: responseData)
        
        return registrationResponse
            
    }
    /// Performa a webauthn registration finish request
    /// - Parameters:
    ///   - startResponse: ``WebauthnRegisterStartResponse`` from the registrationStart request
    ///   - params: ``ASAuthorizationPlatformPublicKeyCredentialRegistration`` from the credential registration request
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageAPIError``
    @available(iOS 16.0, *)
    internal func webauthnRegistrationFinish(startResponse: WebauthnRegisterStartResponse, params: ASAuthorizationPlatformPublicKeyCredentialRegistration?) async throws -> AuthResult {
        guard let params else {
            throw PassageError.unknown
        }
        let url = try self.appUrl(path: "register/webauthn/finish/")
        
        let response = [
            "attestationObject": params.rawAttestationObject?.toBase64Url(),
            "clientDataJSON": params.rawClientDataJSON.toBase64Url()
        ]
     
        let credId = params.credentialID.toBase64Url();
        let handshakeResponse = [
            "rawId": credId,
            "id": credId,
            "type": "public-key",
            "response": response
        ] as [String :Any]
        
        let parameters = [
            "handshake_id": startResponse.handshake.id,
            "handshake_response": handshakeResponse,
            "user_id": startResponse.user.id,
            "cred_type": "passkey"
        ] as [String :Any]
     
        let request = buildRequest(url: url, method: "POST")
        
        let data = try JSONSerialization.data(withJSONObject: parameters, options: [])

        let (responseData, resp) = try await URLSession.shared.upload(for: request, from: data)
        
        try assertValidResponse(response: resp,responseData: responseData)

        let authResponse = try JSONDecoder().decode(WebauthnRegisterFinishResponse.self, from: responseData)

        return authResponse.authResult
    }
    
    /// Peform a webauthn add device start request
    /// - Parameter token: The users access token
    /// - Returns: ``WebauthnRegisterStartResponse``
    /// - Throws ``PassageAPIError``
    @available(iOS 16.0, *)
    internal  func addDeviceStart(token: String) async throws -> WebauthnRegisterStartResponse {
        let url = try self.appUrl(path: "currentuser/devices/start/")
        
        let request = buildAuthenticatedRequest(url: url, method: "POST", token: token)
                
        let (responseData, response) = try await URLSession.shared.data(for: request)
        
        try assertValidResponse(response: response, responseData: responseData)
        
        let addDeviceStartResponse = try JSONDecoder().decode(WebauthnRegisterStartResponse.self, from: responseData)
        
        return addDeviceStartResponse
    }

    /// Perform a webauthn add device finish request
    /// - Parameters:
    ///   - token: The users access token
    ///   - startResponse: The ``WebauthnRegisterStartResponse`` from the  addDeviceStart request
    ///   - params: The ASAuthorizationPlatformPublicKeyCredentialRegistration
    /// - Returns: ``Void``
    /// - Throws: ``PassageAPIError``
    @available(iOS 16.0, *)
    internal func addDeviceFinish(token: String, startResponse: WebauthnRegisterStartResponse, params: ASAuthorizationPlatformPublicKeyCredentialRegistration) async throws -> Void {
        let url = try self.appUrl(path: "currentuser/devices/finish/")
        
        let request = buildAuthenticatedRequest(url: url, method: "POST", token: token)
        
        let response = [
            "attestationObject": params.rawAttestationObject?.toBase64Url(),
            "clientDataJSON": params.rawClientDataJSON.toBase64Url()
        ]
     
        let credId = params.credentialID.toBase64Url();
        let handshakeResponse = [
            "rawId": credId,
            "id": credId,
            "type": "public-key",
            "response": response
        ] as [String :Any]
        
        let parameters = [
            "handshake_id": startResponse.handshake.id,
            "handshake_response": handshakeResponse,
            "user_id": startResponse.user.id,
        ] as [String :Any]
        
        let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
        
        
        let (responseData, resp) = try await URLSession.shared.upload(for: request, from: data)
        
        try assertValidResponse(response: resp, responseData: responseData)
        
    }
    
    /// Send a new login magic link to the user's email or phone
    /// - Parameters:
    ///   - identifier: The users email or phone number
    ///   - path: optional path to append to the redirect url
    ///   - language: optional language string for localizing emails, if no lanuage or an invalid language is provided the application default lanuage will be used
    /// - Returns: ``MagicLink``
    /// - Throws: ``PassageAPIError``
    internal func sendLoginMagicLink(identifier: String, path: String?, language: String? = nil) async throws -> MagicLink {
        let params = [
            "identifier": identifier,
            "path": path,
            "language": language
        ]
        let responseData = try await sendRequest(path: "login/magic-link/", method: .post, params: params)
        let sendMagicLinkResponse = try JSONDecoder().decode(SendMagicLinkResponse.self, from: responseData)
        return sendMagicLinkResponse.magicLink
    }
    
    /// Send a new registration magic link to the users email or phone
    /// - Parameters:
    ///   - identifier: The users email or phone number
    ///   - path: optional path to append to the redirect url
    ///   - language: optional language string for localizing emails, if no lanuage or an invalid language is provided the application default lanuage will be used
    /// - Returns: ``MagicLink``
    /// - Throws: ``PassageAPIError``
    internal func sendRegisterMagicLink(identifier: String, path: String?, language: String? = nil) async throws -> MagicLink {
        let params = [
            "identifier": identifier,
            "path": path,
            "language": language
        ]
        let responseData = try await sendRequest(path: "register/magic-link/", method: .post, params: params)
        let sendMagicLinkResponse = try JSONDecoder().decode(SendMagicLinkResponse.self, from: responseData)
        return sendMagicLinkResponse.magicLink
    }
    
    /// Check the status of a magic link
    /// - Parameter id: magic link id
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageAPIError``
    internal func magicLinkStatus(id: String) async throws -> AuthResult {
        let params = ["id": id]
        let responseData = try await sendRequest(path: "magic-link/status/", method: .post, params: params)
        let magicLinkStatusResponse = try JSONDecoder().decode(MagicLinkStatusResponse.self, from: responseData)
        return magicLinkStatusResponse.authResult
    }
    
    /// Active a magic link
    /// - Parameter magicLink: The magic link to activate
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageAPIError``
    internal func activateMagicLink(magicLink: String) async throws -> AuthResult {
        let params = ["magic_link": magicLink]
        let responseData = try await sendRequest(path: "magic-link/activate/", method: .patch, params: params)
        let activateMagicLinkResponse = try JSONDecoder().decode(ActivateMagicLinkResponse.self, from: responseData)
        return activateMagicLinkResponse.authResult
    }
    
    /// Send a new login one time passcode to the user's email or phone
    /// - Parameters:
    ///   - identifier: The user's email or phone number
    ///   - language: optional language string for localizing emails, if no lanuage or an invalid language is provided the application default lanuage will be used
    /// - Returns: ``OneTimePasscode``
    /// - Throws: ``PassageAPIError``
    func sendLoginOneTimePasscode(identifier: String, language: String?) async throws -> OneTimePasscode {
        let params = [
            "identifier": identifier,
            "language": language
        ]
        let responseData = try await sendRequest(path: "login/otp", method: .post, params: params)
        let oneTimePasscode = try JSONDecoder().decode(OneTimePasscode.self, from: responseData)
        return oneTimePasscode
    }
    
    /// Send a new registration one time passcode to the users email or phone
    /// - Parameters:
    ///   - identifier: The user's email or phone number
    ///   - language: optional language string for localizing emails, if no lanuage or an invalid language is provided the application default lanuage will be used
    /// - Returns: ``OneTimePasscode``
    /// - Throws: ``PassageAPIError``
    func sendRegisterOneTimePasscode(identifier: String, language: String?) async throws -> OneTimePasscode {
        let params = [
            "identifier": identifier,
            "language": language
        ]
        let responseData = try await sendRequest(path: "register/otp", method: .post, params: params)
        let oneTimePasscode = try JSONDecoder().decode(OneTimePasscode.self, from: responseData)
        return oneTimePasscode
    }
    
    /// Active a one time passcode
    /// - Parameters:
    ///   - otp: The user's one time passcode
    ///   - otpId: The one time passcode id
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageAPIError``
    func activateOneTimePasscode(otp: String, otpId: String) async throws -> AuthResult {
        let params = [
            "otp": otp,
            "otp_id": otpId
        ]
        let responseData = try await sendRequest(path: "otp/activate", method: .post, params: params)
        let activateOneTimePasscodeResponse = try JSONDecoder().decode(ActivateOneTimePasscodeResponse.self, from: responseData)
        return activateOneTimePasscodeResponse.authResult
    }
    
    /// Get the detail for the current user
    /// - Parameter token: The user's access token
    /// - Returns: ``PassageUserInfo``
    /// - Throws: ``PassageAPIError``
    internal func currentUser(token: String) async throws -> PassageUserInfo {
        let url = try self.appUrl(path: "currentuser/")

        let request = buildAuthenticatedRequest(url: url, method: "GET", token: token)
        
        let (responseData, response) = try await URLSession.shared.data(for: request)

        try assertValidResponse(response: response, responseData: responseData)
        
        let currentUserResponse = try JSONDecoder().decode(CurrentUserResponse.self, from: responseData)
        
        return currentUserResponse.user
        
    }
    
    /// Make a request to get the current user's devices
    /// - Parameter token: The user's access token
    /// - Returns: Array of ``DeviceInfo``
    /// - Throws: ``PassageAPIError``
    internal func listDevices(token: String) async throws -> [DeviceInfo] {
        let url = try self.appUrl(path: "currentuser/devices/")
        
        let request = buildAuthenticatedRequest(url: url, method: "GET", token: token)
        
        let (responseData, response) = try await URLSession.shared.data(for: request)

        try assertValidResponse(response: response, responseData: responseData)
        
        let listDevicesResponse = try JSONDecoder().decode(ListDevicesResponse.self, from: responseData)
        
        return listDevicesResponse.devices

        
    }
    
    /// Change the current user's email, will send a magic link to confirm
    /// - Parameters:
    ///   - token: The user's access token
    ///   - newEmail: New email address
    ///   - magicLinkPath: optional path to append to the redirect url
    ///   - redirectUrl: optional path to append to the redirect url
    ///   - language: optional language string for localizing emails, if no lanuage or an invalid language is provided the application default lanuage will be used
    /// - Returns: ``MagicLink``
    /// - Throws: ``PassageAPIError``
    internal func changeEmail(token: String, newEmail: String, magicLinkPath: String?, redirectUrl: String?, language: String?) async throws -> MagicLink {
        let url = try self.appUrl(path: "currentuser/email/")

        let request = buildAuthenticatedRequest(url: url, method: "PATCH", token: token)
        
        var jsonObject = ["new_email": newEmail]
        if (redirectUrl != nil) {
            jsonObject["redirect_url"] = redirectUrl
        }
        if (magicLinkPath != nil) {
            jsonObject["magic_link_path"] = magicLinkPath
        }
        if(language != nil) {
            jsonObject["language"] = language
        }
        let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
        
        let (responseData, response) = try await URLSession.shared.upload(for: request, from: data)
        
        try assertValidResponse(response: response, responseData: responseData)
        
        let changeEmailResponse = try JSONDecoder().decode(ChangeEmailResponse.self, from: responseData)
        
        return changeEmailResponse.magicLink

    }
    
    /// Change the current user's phone, will send a magic link to confirm
    /// - Parameters:
    ///   - token: The user's access token
    ///   - newPhone: The user's new phone number
    ///   - magicLinkPath: optional path to append to the redirect url
    ///   - redirectUrl: optional path to append to the redirect url
    ///   - language: optional language string for localizing emails, if no lanuage or an invalid language is provided the application default lanuage will be used
    /// - Returns: ``MagicLink``
    /// - Throws: ``PassageAPIError``
    internal func changePhone(token: String, newPhone: String, magicLinkPath: String?, redirectUrl: String?, language: String?) async throws -> MagicLink {
        
      let url = try self.appUrl(path: "currentuser/phone/")
    
      let request = buildAuthenticatedRequest(url: url, method: "PATCH", token: token)
        
      var jsonObject = ["new_phone": newPhone]
        
      if (redirectUrl != nil) {
          jsonObject["redirect_url"] = redirectUrl
      }
      if (magicLinkPath != nil) {
          jsonObject["magic_link_path"] = magicLinkPath
      }
      if(language != nil) {
          jsonObject["language"] = language
      }
      let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
      
      let (responseData, response) = try await URLSession.shared.upload(for: request, from: data)
      
        try assertValidResponse(response: response, responseData: responseData)
      
      let changePhoneResponse = try JSONDecoder().decode(ChangePhoneResponse.self, from: responseData)
          
        return changePhoneResponse.magicLink
    }
    
    /// Update the user's device, only supports the friendly name currently
    /// - Parameters:
    ///   - token: The user's access token
    ///   - deviceId: The id of the device to update
    ///   - friendlyName: The device's new friendly name
    /// - Returns: ``DeviceInfo``
    /// - Throws: ``PassageAPIError``
    internal func updateDevice(token: String, deviceId: String, friendlyName: String) async throws -> DeviceInfo {
        let url = try self.appUrl(path: "currentuser/devices/\(deviceId)/")
        
        let request = buildAuthenticatedRequest(url: url, method: "PATCH", token: token)
                
        let data: Data = try JSONSerialization.data(withJSONObject: ["friendly_name": friendlyName], options: [])
        
        let (responseData, response) = try await URLSession.shared.upload(for: request, from: data)
        
        try assertValidResponse(response: response, responseData: responseData)
        
        let updateDeviceResponse = try JSONDecoder().decode(UpdateDeviceResponse.self, from: responseData)
        
        return updateDeviceResponse.device
    }
    
    /// Revoke the device
    /// - Parameters:
    ///   - token: The user's access token
    ///   - deviceId: The id of the device to revoke
    /// - Returns: Void
    /// - Throws: ``PassageAPIError``
    internal func revokeDevice(token: String, deviceId: String) async throws {
        let url = try self.appUrl(path: "currentuser/devices/\(deviceId)/")
        
        let request = buildAuthenticatedRequest(url: url, method: "DELETE", token: token)
        
        let (responseData, response) = try await URLSession.shared.data(for: request)
        
        try assertValidResponse(response: response, responseData: responseData)
        
    }
    
    /// Load a user
    /// - Parameter The identifier (email or phone) of the user to get
    /// - Returns: ``PassageUserInfo``
    /// - Throws: ``PassageAPIError``
    internal func getUser(identifier: String) async throws -> PassageUserInfo {
        let url = try self.appUrl(path: "users/?identifier=\(identifier.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)")
        
        let request = buildRequest(url: url, method: "GET")
        
        let (responseData, response) = try await URLSession.shared.data(for: request)
        
        try assertValidResponse(response: response, responseData: responseData)
        
        let getUserResponse = try JSONDecoder().decode(GetUserResponse.self, from: responseData)
        
        return getUserResponse.user

    }
    
    /// Refresh a session using a refresh token
    ///  - Parameter The user's refresh token
    ///  - Returns ``AuthResult``
    ///  - Throws ``PassageAPIError``
    internal func refresh(refreshToken: String) async throws -> AuthResult {
        let url = try self.appUrl(path: "tokens/")
        
        let request = buildRequest(url: url, method: "POST")
        
        let data = try JSONSerialization.data(withJSONObject: ["refresh_token": refreshToken], options: [])
        
        let (responseData, response) = try await URLSession.shared.upload(for: request, from: data)
                
        try assertValidResponse(response: response, responseData: responseData)
        
        let refreshResponse = try JSONDecoder().decode(RefreshResponse.self, from: responseData)
        
        return refreshResponse.authResult
    }
    
    /// Sign out the current user's session
    /// - Parameter The user's refresh token
    /// - Returns: Void
    /// - Throws: ``PassageAPIError``
    internal func signOut(refreshToken: String) async throws {
        let url = try self.appUrl(path: "tokens/?refresh_token=\(refreshToken.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)")
        
        let request = buildRequest(url: url, method: "DELETE")
        
        let (responseData, response) = try await URLSession.shared.data(for: request)
        
        try assertValidResponse(response: response, responseData: responseData)
    }
    
    
    // MARK: Private funcs.
 
    
    /// Generate a URL for the requested path.
    ///
    /// Uses the path passed in and creates a valid Url to that path based on the baseUrl
    ///
    /// - Parameter path: The path to make a request to. Will be appended to the base url and the appId will be interpolated.
    /// - Returns: a `URL` that can be used to make the network request.
    /// - Throws: ``PassageAPIError``
    internal func appUrl(path: String) throws -> URL {
        guard let url = URL(string: "\(self.baseUrl!)/v1/apps/\(self.appId!)/\(path)") else {
            throw PassageAPIError.malformedUrl
        }
        return url
    }
    
    

    internal func assertValidResponse(response: URLResponse, responseData: Data? = nil) throws {
        let successStatusCodes = [200, 201]
        guard let httpResponse = response as? HTTPURLResponse, successStatusCodes.contains(httpResponse.statusCode) else {
            let httpResponse = response as? HTTPURLResponse
            
            var errorResponseBody: PassageErrorResponseBody? = nil
            
            if (responseData != nil) {
                errorResponseBody = try JSONDecoder().decode(PassageErrorResponseBody.self, from: responseData!)
            }

            let errorResponse = PassageAPIErrorResponse(code: httpResponse!.statusCode, message: httpResponse!.description, body: errorResponseBody)
            
            switch httpResponse?.statusCode {
            case 400:
                throw PassageAPIError.badRequest(errorResponse)
            case 401:
                throw PassageAPIError.unauthorized(errorResponse)
            case 404:
                throw PassageAPIError.notFound(errorResponse)
            case 409:
                throw PassageAPIError.conflict(errorResponse)
            case 500:
                throw PassageAPIError.internalServerError(errorResponse)
            default:
                throw PassageAPIError.failedResponse(errorResponse)
            }
        }
    }

    
    internal func logData(data: Data) {
        print("The data: \(String(bytes: data, encoding: .utf8)!)")
    }
    
    internal func buildAuthenticatedRequest(url: URL, method: String, token: String) -> URLRequest {
        
        var request = buildRequest(url: url, method: method)
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    internal func buildRequest(url: URL, method: String) -> URLRequest {
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        
        // Set the version header
        request.setValue("passage-ios v\(PassageSettings.shared.version)", forHTTPHeaderField: "Passage-Version")
        
        request.httpMethod = method
                
        return request
    }
    
    private func sendRequest(path: String, method: RequestMethod, params: [String: String?]) async throws -> Data {
        let url = try appUrl(path: path)
        let request = buildRequest(url: url, method: method.rawValue)
        var jsonObject: [String: String] = [:]
        for (key, value) in params {
            guard let value else { continue }
            jsonObject[key] = value
        }
        let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
        let (responseData, response) = try await URLSession.shared.upload(for: request, from: data)
        try assertValidResponse(response: response,responseData: responseData)
        return responseData
    }
    
}
