import AuthenticationServices
@testable import Passage

final class MockPassageAPIClient: PassageAuthAPIClient {
    var appId: String?
    
    var baseUrl: String?
    
    func appInfo() async throws -> Passage.AppInfo {
        return testAppInfo
    }
    
    @available(iOS 16.0, *)
    func webauthnLoginStart() async throws -> Passage.WebauthnLoginStartResponse {
        return testLoginStartResponse
    }
    
    @available(iOS 16.0, *)
    func webauthnLoginFinish(startResponse: Passage.WebauthnLoginStartResponse, credentialAssertion: ASAuthorizationPlatformPublicKeyCredentialAssertion?) async throws -> Passage.AuthResult {
        return testLoginFinishResponse
    }
    
    @available(iOS 16.0, *)
    func webauthnLoginWithIdentifierStart(identifier: String) async throws -> Passage.WebauthnLoginStartResponse {
        throw PassageError.unknown
    }
    
    @available(iOS 16.0, *)
    func webauthnLoginWithIdentifierFinish(startResponse: Passage.WebauthnLoginStartResponse, credentialAssertion: ASAuthorizationPlatformPublicKeyCredentialAssertion) async throws -> Passage.AuthResult {
        throw PassageError.unknown
    }
    
    @available(iOS 16.0, *)
    func webauthnRegistrationStart(identifier: String) async throws -> Passage.WebauthnRegisterStartResponse {
        guard identifier == unregisteredUserEmail else {
            throw PassageError.userAlreadyExists
        }
        return testRegisterStartResponse
    }
    
    @available(iOS 16.0, *)
    func webauthnRegistrationFinish(startResponse: Passage.WebauthnRegisterStartResponse, params: ASAuthorizationPlatformPublicKeyCredentialRegistration?) async throws -> Passage.AuthResult {
        return AuthResult(authToken: "TEST_TOKEN", redirectURL: "/", refreshToken: nil, refreshTokenExpiration: nil)
    }
    
    @available(iOS 16.0, *)
    func addDeviceStart(token: String) async throws -> Passage.WebauthnRegisterStartResponse {
        throw PassageError.unknown
    }
    
    @available(iOS 16.0, *)
    func addDeviceFinish(token: String, startResponse: Passage.WebauthnRegisterStartResponse, params: ASAuthorizationPlatformPublicKeyCredentialRegistration) async throws -> Passage.DeviceInfo {
        throw PassageError.unknown
    }
    
    func sendLoginMagicLink(identifier: String, path: String?, language: String? = nil) async throws -> Passage.MagicLink {
        guard identifier == registeredUserEmail else {
            throw PassageError.unknown
        }
        return Passage.MagicLink(id: "TEST_MAGIC_LINK")
    }
    
    func sendRegisterMagicLink(identifier: String, path: String?, language: String? = nil) async throws -> Passage.MagicLink {
        guard identifier == unregisteredUserEmail else {
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
    
    func sendLoginOneTimePasscode(identifier: String, language: String?) async throws -> Passage.OneTimePasscode {
        guard identifier == registeredUserEmail else {
            throw PassageError.unknown
        }
        return Passage.OneTimePasscode(id: "TEST_ONE_TIME_PASSCODE")
    }
    
    func sendRegisterOneTimePasscode(identifier: String, language: String?) async throws -> Passage.OneTimePasscode {
        guard identifier == unregisteredUserEmail else {
            throw PassageError.userAlreadyExists
        }
        return Passage.OneTimePasscode(id: "TEST_ONE_TIME_PASSCODE")
    }
    
    func activateOneTimePasscode(otp: String, otpId: String) async throws -> Passage.AuthResult {
        throw PassageError.unknown
    }
    
    func currentUser(token: String) async throws -> Passage.PassageUserInfo {
        throw PassageError.unknown
    }
    
    func listDevices(token: String) async throws -> [Passage.DeviceInfo] {
        throw PassageError.unknown
    }
    
    func changeEmail(token: String, newEmail: String, magicLinkPath: String?, redirectUrl: String?, language: String?) async throws -> Passage.MagicLink {
        throw PassageError.unknown
    }
    
    func changePhone(token: String, newPhone: String, magicLinkPath: String?, redirectUrl: String?, language: String?) async throws -> Passage.MagicLink {
        throw PassageError.unknown
    }
    
    func updateDevice(token: String, deviceId: String, friendlyName: String) async throws -> Passage.DeviceInfo {
        throw PassageError.unknown
    }
    
    func revokeDevice(token: String, deviceId: String) async throws {
        throw PassageError.unknown
    }
    
    func getUser(identifier: String) async throws -> Passage.PassageUserInfo {
        guard identifier == registeredUserEmail else {
            throw PassageError.userDoesNotExist
        }
        return PassageUserInfo(
            createdAt: "",
            email: "",
            emailVerified: true,
            id: "",
            lastLoginAt: "",
            loginCount: 1,
            phone: "",
            phoneVerified: true,
            status: "",
            updatedAt: "",
            webauthn: true,
            webauthnDevices: [],
            webauthnTypes: []
        )
    }
    
    func refresh(refreshToken: String) async throws -> AuthResult {
        return AuthResult(
            authToken: "TEST_TOKEN",
            redirectURL: "/",
            refreshToken: "TEST_REFRESH_TOKEN",
            refreshTokenExpiration: 6000
        )
    }
    
    func signOut(refreshToken: String) async throws {
        // do nothing
    }
    
}
