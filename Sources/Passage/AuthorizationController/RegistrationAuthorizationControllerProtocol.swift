import AuthenticationServices

@available(iOS 16.0, *)
protocol RegistrationAuthorizationControllerProtocol: NSObject, ASAuthorizationControllerDelegate {
    
    func register(
        from response: RegisterWebAuthnStartResponse,
        identifier: String,
        includeSecurityKeyOption: Bool
    ) async throws -> ASAuthorizationPublicKeyCredentialRegistration?
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error)
    
}
