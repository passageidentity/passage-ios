import AuthenticationServices

@available(iOS 16.0, *)
protocol RegistrationAuthorizationControllerProtocol: NSObject, ASAuthorizationControllerDelegate {
    
    func register(from response: WebauthnRegisterStartResponse, identifier: String) async throws -> ASAuthorizationPlatformPublicKeyCredentialRegistration?
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error)
    
}
