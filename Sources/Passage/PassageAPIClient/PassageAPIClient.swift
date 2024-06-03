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
    
    /// The language messages to user should be sent in.
    ///
    /// This can be configured in the Passage.plist file.
    internal var language: String?
    
    /// Private initializer
    ///
    /// PassageAPIClient cannot be instantiated directly, use the shared prop to make network requeists.
    ///
    /// This initializer will read the appId and baseURl from the Passage.plist file.
    private init() {
        self.appId = PassageSettings.shared.appId!
        self.baseUrl = PassageSettings.shared.apiUrl ?? "https://auth.passage.id"
        self.language = PassageSettings.shared.language
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
    
    /// Get social authorization url
    /// - Parameters:
    ///   - queryParams: Request query parameters
    /// - Returns: ``URL``
    func getAuthUrl(queryParams: String) throws -> URL {
        return try self.appUrl(path: "social/authorize?\(queryParams)")
    }
    
    /// Exchange social auth code for AuthResult
    /// - Parameters:
    ///   - code: Social auth code
    ///   - verifier: Social auth verifier
    /// - Returns: ``AuthResult``
    func exchange(code: String, verifier: String) async throws -> AuthResult {
        let url = try self.appUrl(path: "social/token?code=\(code)&verifier=\(verifier)")
        let request = buildRequest(url: url, method: "GET")
        let (responseData, response) = try await URLSession.shared.data(for: request)
        try assertValidResponse(response: response, responseData: responseData)
        let authResultResponse = try JSONDecoder().decode(AuthResultResponse.self, from: responseData)
        return authResultResponse.authResult
    }
    
    /// Exchange social auth code and id token for AuthResult
    /// - Parameters:
    ///   - code: Social auth code
    ///   - idToken: Social id token
    /// - Returns: ``AuthResult``
    func exchange(code: String, idToken: String) async throws -> AuthResult {
        let url = try self.appUrl(path: "social/id_token")
        let request = buildRequest(url: url, method: "POST")
        let params = [
            "code": code,
            "id_token": idToken,
            "connection_type": "apple"
        ]
        let data = try JSONSerialization.data(withJSONObject: params, options: [])
        let (responseData, response) = try await URLSession.shared.upload(for: request, from: data)
        try assertValidResponse(response: response, responseData: responseData)
        let authResultResponse = try JSONDecoder().decode(AuthResultResponse.self, from: responseData)
        return authResultResponse.authResult
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
        jsonObject["language"] = language ?? self.language
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
        jsonObject["language"] = language ?? self.language
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
