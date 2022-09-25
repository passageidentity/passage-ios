//
//  PassageAPIClient.swift
//  Shiny
//
//  Created by blayne bayer on 8/23/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import AuthenticationServices
import os

/// Passage API Client
///
/// Implements all the network requests to the Passage API's 
internal class PassageAPIClient : PassageAuthAPIClient {

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
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        
        request.httpMethod = "GET"
        
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
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)

        request.httpMethod = "POST"
        
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
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        
        let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
        

        request.httpMethod = "POST"

        let (responseData, resp) = try await URLSession.shared.upload(for: request, from: data)
        
        try assertValidResponse(response: resp, responseData: responseData)
        
        let authResponse = try JSONDecoder().decode(WebauthnLoginFinishResponse.self, from: responseData)

        return authResponse.auth_result
    }
    
    /// Peform a webauthn login start request for the specified identifier
    /// - Parameter identifier: Email address or phone number
    /// - Returns: ``WebauthnLoginStartResponse``
    /// - Throws: ``PassageAPIError``
    @available(iOS 16.0, *)
    internal func webauthnLoginWithIdentifierStart(identifier: String) async throws -> WebauthnLoginStartResponse {
        
        let url = try self.appUrl(path: "login/webauthn/start/")
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)

        let data = try JSONSerialization.data(withJSONObject: ["identifier": identifier], options: [])
        
        request.httpMethod = "POST"
        
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
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        
        let data = try JSONSerialization.data(withJSONObject: parameters, options: [])

        request.httpMethod = "POST"

        let (responseData, resp) = try await URLSession.shared.upload(for: request, from: data)
        
        try assertValidResponse(response: resp, responseData: responseData)
        
        let authResponse = try JSONDecoder().decode(WebauthnLoginFinishResponse.self, from: responseData)

        return authResponse.auth_result
        
    }


    /// Perform a webauthn registration start request
    /// - Parameter identifier: The users identifier (email or phone number)
    /// - Returns: ``WebauthnRegisterStartResponse``
    /// - Throws: ``PassageAPIError``
    @available(iOS 16.0, *)
    internal func webauthnRegistrationStart(identifier: String) async throws -> WebauthnRegisterStartResponse {
        let url = try self.appUrl(path: "register/webauthn/start/")
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)

        let data = try JSONSerialization.data(withJSONObject: ["identifier": identifier], options: [])
        request.httpMethod = "POST"
        let (responseData, response) = try await URLSession.shared.upload(for: request, from: data)
        
        try assertValidResponse(response: response, responseData: responseData, successStatusCode: 200)
        
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
     
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        
        let data = try JSONSerialization.data(withJSONObject: parameters, options: [])

        request.httpMethod = "POST"

        let (responseData, resp) = try await URLSession.shared.upload(for: request, from: data)
        
        try assertValidResponse(response: resp,responseData: responseData, successStatusCode: 201)

        let authResponse = try JSONDecoder().decode(WebauthnRegisterFinishResponse.self, from: responseData)

        return authResponse.auth_result
    }
    
    /// Peform a webauthn add device start request
    /// - Parameter token: The users access token
    /// - Returns: ``WebauthnRegisterStartResponse``
    /// - Throws ``PassageAPIError``
    @available(iOS 16.0, *)
    internal  func addDeviceStart(token: String) async throws -> WebauthnRegisterStartResponse {
        let url = try self.appUrl(path: "currentuser/devices/start/")
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)

        let tokenString = "Bearer \(token)"
        request.addValue("\(tokenString)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "POST"
        
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
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)

        let tokenString = "Bearer \(token)"
        request.addValue("\(tokenString)", forHTTPHeaderField: "Authorization")
        
        
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
        
        request.httpMethod = "POST"
        
        let (responseData, resp) = try await URLSession.shared.upload(for: request, from: data)
        
        try assertValidResponse(response: resp, responseData: responseData, successStatusCode: 201)

//        let addDeviceResponse = try JSONDecoder().decode(WebauthnAddDeviceFinishResponse.self, from: responseData)

        
    }
    
    /// Send a new login magic link to the user's email or phone
    /// - Parameters:
    ///   - identifier: The users email or phone number
    ///   - path: optional path to append to the redirect url
    /// - Returns: ``MagicLink``
    /// - Throws: ``PassageAPIError``
    internal func sendLoginMagicLink(identifier: String, path: String?) async throws -> MagicLink {
        let url = try self.appUrl(path: "login/magic-link/")
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        
        var data: Data
        if ( path != nil) {
            data = try JSONSerialization.data(withJSONObject: ["identifier": identifier, path: path], options: [])
        }
        else {
            data = try JSONSerialization.data(withJSONObject: ["identifier": identifier], options: [])
        }
        
        request.httpMethod = "POST"
        
        let (responseData, response) = try await URLSession.shared.upload(for: request, from: data)

        try assertValidResponse(response: response, responseData: responseData)
        
        let sendMagicLinkResponse = try JSONDecoder().decode(SendMagicLinkResponse.self, from: responseData)
        
        return sendMagicLinkResponse.magic_link
    }
    
    /// Send a new registration magic link to the users email or phone
    /// - Parameters:
    ///   - identifier: The users email or phone number
    ///   - path: optional path to append to the redirect url
    /// - Returns: ``MagicLink``
    internal func sendRegisterMagicLink(identifier: String, path: String?) async throws -> MagicLink {
        let url = try self.appUrl(path: "register/magic-link/")
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        
        var data: Data
        if ( path != nil) {
            data = try JSONSerialization.data(withJSONObject: ["identifier": identifier, path: path], options: [])
        }
        else {
            data = try JSONSerialization.data(withJSONObject: ["identifier": identifier], options: [])
        }
        
        request.httpMethod = "POST"
        
        let (responseData, response) = try await URLSession.shared.upload(for: request, from: data)

        try assertValidResponse(response: response,responseData: responseData, successStatusCode: 201)
        
        let sendMagicLinkResponse = try JSONDecoder().decode(SendMagicLinkResponse.self, from: responseData)
        
        return sendMagicLinkResponse.magic_link
    }
    
    /// Check the status of a magic link
    /// - Parameter id: magic link id
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageAPIError``
    internal func magicLinkStatus(id: String) async throws -> AuthResult {
        let url = try self.appUrl(path: "magic-link/status/")
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        
        let data = try JSONSerialization.data(withJSONObject: ["id": id], options: [])
        
        request.httpMethod = "POST"
        
        let (responseData, response) = try await URLSession.shared.upload(for: request, from: data)
                
        try assertValidResponse(response: response, responseData: responseData)
        
        let magicLinkStatusResponse = try JSONDecoder().decode(MagicLinkStatusResponse.self, from: responseData)
        
        return magicLinkStatusResponse.auth_result
    }
    
    
    /// Active a magic link
    /// - Parameter magicLink: The magic link to activate
    /// - Returns: ``AuthResult``
    /// - Throws: ``PassageAPIError``
    internal func activateMagicLink(magicLink: String) async throws -> AuthResult {
        let url = try self.appUrl(path: "magic-link/activate/")
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        
        let data = try JSONSerialization.data(withJSONObject: ["magic_link": magicLink], options: [])
        
        request.httpMethod = "PATCH"
        
        let (responseData, response) = try await URLSession.shared.upload(for: request, from: data)
                
        try assertValidResponse(response: response, responseData: responseData)
        
        let activateMagicLinkResponse = try JSONDecoder().decode(ActivateMagicLinkResponse.self, from: responseData)
        
        return activateMagicLinkResponse.auth_result
    }
    
    /// Get the detail for the current user
    /// - Parameter token: The user's access token
    /// - Returns: ``PassageUserDetails``
    /// - Throws: ``PassageAPIError``
    internal func currentUser(token: String) async throws -> PassageUserDetails {
        let url = try self.appUrl(path: "currentuser/")
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        
        let tokenString = "Bearer \(token)"
        request.addValue("\(tokenString)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        
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
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        
        let tokenString = "Bearer \(token)"
        request.addValue("\(tokenString)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        
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
    /// - Returns: ``MagicLink``
    /// - Throws: ``PassageAPIError``
    internal func changeEmail(token: String, newEmail: String, magicLinkPath: String?, redirectUrl: String?) async throws -> MagicLink {
        let url = try self.appUrl(path: "currentuser/email/")
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        
        let tokenString = "Bearer \(token)"
        request.addValue("\(tokenString)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "PATCH"
        
        var data: Data
        if ( magicLinkPath != nil && redirectUrl != nil) {
            data = try JSONSerialization.data(withJSONObject: ["new_email": newEmail, "magic_link_path": magicLinkPath, "redirect_url": redirectUrl], options: [])
        }
        else if ( magicLinkPath != nil) {
            data = try JSONSerialization.data(withJSONObject: ["new_email": newEmail, "magic_link_path": magicLinkPath], options: [])
        }
        else if ( redirectUrl != nil ) {
            data = try JSONSerialization.data(withJSONObject: ["new_email": newEmail,  "redirect_url": redirectUrl], options: [])
        }
        else {
            data = try JSONSerialization.data(withJSONObject: ["new_email": newEmail], options: [])
        }
        
        let (responseData, response) = try await URLSession.shared.upload(for: request, from: data)
        
        try assertValidResponse(response: response, responseData: responseData)
        
        let changeEmailResponse = try JSONDecoder().decode(ChangeEmailResponse.self, from: responseData)
        
        return changeEmailResponse.magic_link

    }
    
    /// Change the current user's phone, will send a magic link to confirm
    /// - Parameters:
    ///   - token: The user's access token
    ///   - newPhone: The user's new phone number
    ///   - magicLinkPath: optional path to append to the redirect url
    ///   - redirectUrl: optional path to append to the redirect url
    /// - Returns: ``MagicLink``
    /// - Throws: ``PassageAPIError``
    internal func changePhone(token: String, newPhone: String, magicLinkPath: String?, redirectUrl: String?) async throws -> MagicLink {
        
      let url = try self.appUrl(path: "currentuser/phone/")
      var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
      
      let tokenString = "Bearer \(token)"
      request.addValue("\(tokenString)", forHTTPHeaderField: "Authorization")
      
      request.httpMethod = "PATCH"
      
      var data: Data
      if ( magicLinkPath != nil && redirectUrl != nil) {
          data = try JSONSerialization.data(withJSONObject: ["new_phone": newPhone, "magic_link_path": magicLinkPath, "redirect_url": redirectUrl], options: [])
      }
      else if ( magicLinkPath != nil) {
          data = try JSONSerialization.data(withJSONObject: ["new_phone": newPhone, "magic_link_path": magicLinkPath], options: [])
      }
      else if ( redirectUrl != nil ) {
          data = try JSONSerialization.data(withJSONObject: ["new_phone": newPhone,  "redirect_url": redirectUrl], options: [])
      }
      else {
          data = try JSONSerialization.data(withJSONObject: ["new_phone": newPhone,], options: [])
      }
      
      let (responseData, response) = try await URLSession.shared.upload(for: request, from: data)
      
        try assertValidResponse(response: response, responseData: responseData)
      
      let changePhoneResponse = try JSONDecoder().decode(ChangePhoneResponse.self, from: responseData)
          
        return changePhoneResponse.magic_link
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
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        
        let tokenString = "Bearer \(token)"
        request.addValue("\(tokenString)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "PATCH"
        
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
                
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        
        let tokenString = "Bearer \(token)"
        request.addValue("\(tokenString)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "DELETE"
        
        let (responseData, response) = try await URLSession.shared.data(for: request)
        
        try assertValidResponse(response: response, responseData: responseData)
        
    }
    
    /// Load a user
    /// - Parameter The identifier (email or phone) of the user to get
    /// - Returns: ``PassageUser``
    /// - Throws: ``PassageAPIError``
    internal func getUser(identifier: String) async throws -> PassageUser {
        let url = try self.appUrl(path: "users/?identifier=\(identifier.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)")
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        
        request.httpMethod = "GET"
        
        let (responseData, response) = try await URLSession.shared.data(for: request)
        
        try assertValidResponse(response: response, responseData: responseData)
        
        let getUserResponse = try JSONDecoder().decode(GetUserResponse.self, from: responseData)
        
        return getUserResponse.user

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
    
    

    internal func assertValidResponse(response: URLResponse, responseData: Data? = nil, successStatusCode: Int = 200) throws {
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == successStatusCode else {
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
    
}
