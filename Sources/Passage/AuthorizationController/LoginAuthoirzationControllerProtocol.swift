import Foundation
import os
import AuthenticationServices

@available(iOS 16.0, *)
protocol LoginAuthorizationControllerProtocol: NSObject, ASAuthorizationControllerDelegate {
    
    func login(from response: LoginWebAuthnStartResponse) async throws -> ASAuthorizationPublicKeyCredentialAssertion?
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error)
    
}
