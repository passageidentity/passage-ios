import Foundation
import os
import AuthenticationServices

@available(iOS 16.0, *)
protocol LoginAuthorizationControllerProtocol: NSObject, ASAuthorizationControllerDelegate {
    
    func login(from response: WebauthnLoginStartResponse) async throws -> ASAuthorizationPlatformPublicKeyCredentialAssertion?
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error)
    
    func requestSecurityKeyAssertion(from response: WebauthnLoginStartResponse) async throws -> ASAuthorizationSecurityKeyPublicKeyCredentialAssertion?
    
}
