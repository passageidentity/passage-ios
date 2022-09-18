import AuthenticationServices
@testable import Passage

@available(iOS 16.0, *)
class MockLoginAuthorizationController : NSObject, ASAuthorizationControllerDelegate, LoginAuthorizationControllerProtocol {
    
    func loginWithIdentifier(from response: Passage.WebauthnLoginStartResponse, identifier: String) async throws -> ASAuthorizationPlatformPublicKeyCredentialAssertion {
        throw PassageError.unknown
    }
    
    func login(from response: Passage.WebauthnLoginStartResponse) async throws -> ASAuthorizationPlatformPublicKeyCredentialAssertion? {
        return nil
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
    }
    
}
