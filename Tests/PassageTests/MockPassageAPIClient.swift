import AuthenticationServices
@testable import Passage

final class MockPassageAPIClient: PassageAuthAPIClient {
    var appId: String?
    
    var baseUrl: String?
    
    func appInfo() async throws -> Passage.AppInfo {
        return testAppInfo
    }
    
    func webauthnLoginStart() async throws -> Passage.WebauthnLoginStartResponse {
        return testLoginStartResponse
    }
    
    @available(iOS 15.0, *)
    func webauthnLoginFinish(startResponse: Passage.WebauthnLoginStartResponse, credentialAssertion: ASAuthorizationPlatformPublicKeyCredentialAssertion?) async throws -> Passage.AuthResult {
        return testLoginFinishResponse
    }
    
    func webauthnLoginWithIdentifierStart(identifier: String) async throws -> Passage.WebauthnLoginStartResponse {
        throw PassageError.unknown
    }
    
    @available(iOS 15.0, *)
    func webauthnLoginWithIdentifierFinish(startResponse: Passage.WebauthnLoginStartResponse, credentialAssertion: ASAuthorizationPlatformPublicKeyCredentialAssertion) async throws -> Passage.AuthResult {
        throw PassageError.unknown
    }
    
    func webauthnRegistrationStart(identifier: String) async throws -> Passage.WebauthnRegisterStartResponse {
        guard identifier == "unregistered-test-user@passage.id" else {
            throw PassageError.userAlreadyExists
        }
        return testRegisterStartResponse
    }
    
    @available(iOS 15.0, *)
    func webauthnRegistrationFinish(startResponse: Passage.WebauthnRegisterStartResponse, params: ASAuthorizationPlatformPublicKeyCredentialRegistration?) async throws -> Passage.AuthResult {
        return AuthResult(auth_token: "TEST_TOKEN", redirect_url: nil)
    }
    
    func addDeviceStart(token: String) async throws -> Passage.WebauthnRegisterStartResponse {
        throw PassageError.unknown
    }
    
    @available(iOS 15.0, *)
    func addDeviceFinish(token: String, startResponse: Passage.WebauthnRegisterStartResponse, params: ASAuthorizationPlatformPublicKeyCredentialRegistration) async throws -> Passage.AuthResult {
        throw PassageError.unknown
    }
    
    func sendLoginMagicLink(identifier: String, path: String?) async throws -> Passage.MagicLink {
        guard identifier == "registered-test-user@passage.id" else {
            throw PassageError.unknown
        }
        return Passage.MagicLink(id: "TEST_MAGIC_LINK")
    }
    
    func sendRegisterMagicLink(identifier: String, path: String?) async throws -> Passage.MagicLink {
        guard identifier == "unregistered-test-user@passage.id" else {
            throw PassageError.userAlreadyExists
        }
        return Passage.MagicLink(id: "TEST_MAGIC_LINK")
    }
    
    func magicLinkStatus(id: String) async throws -> Passage.AuthResult {
        throw PassageError.unknown
    }
    
    func activateMagicLink(magicLink: String) async throws -> Passage.AuthResult {
        throw PassageError.unknown
    }
    
    func currentUser(token: String) async throws -> Passage.PassageUserDetails {
        throw PassageError.unknown
    }
    
    func listDevices(token: String) async throws -> [Passage.DeviceInfo] {
        throw PassageError.unknown
    }
    
    func changeEmail(token: String, newEmail: String, magicLinkPath: String?, redirectUrl: String?) async throws -> Passage.MagicLink {
        throw PassageError.unknown
    }
    
    func changePhone(token: String, newPhone: String, magicLinkPath: String?, redirectUrl: String?) async throws -> Passage.MagicLink {
        throw PassageError.unknown
    }
    
    func updateDevice(token: String, deviceId: String, friendlyName: String) async throws -> Passage.DeviceInfo {
        throw PassageError.unknown
    }
    
    func revokeDevice(token: String, deviceId: String) async throws {
        throw PassageError.unknown
    }
    
    func getUser(identifier: String) async throws -> Passage.PassageUser {
        guard identifier == "registered-test-user@passage.id" else {
            throw PassageError.userDoesNotExist
        }
        return PassageUser(id: "TEST_ID", email_verified: true, phone_verified: true, webauthn: true)
    }
    
    
}
