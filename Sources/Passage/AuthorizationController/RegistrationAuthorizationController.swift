import Foundation
import os
import AuthenticationServices

@available(iOS 16.0, *)
class RegistrationAuthorizationController : NSObject, ASAuthorizationControllerDelegate, RegistrationAuthorizationControllerProtocol {
    
    private typealias CredentialRegistrationCheckedThrowingContinuation = CheckedContinuation<
        ASAuthorizationPublicKeyCredentialRegistration,
        Error
    >
    private var credentialRegistrationCheckedThrowingContinuation: CredentialRegistrationCheckedThrowingContinuation? = nil
    
    static var shared: RegistrationAuthorizationControllerProtocol = RegistrationAuthorizationController()
    
    func register(
        from response: WebauthnRegisterStartResponse,
        identifier: String,
        includeSecurityKeyOption: Bool = false
    ) async throws -> ASAuthorizationPublicKeyCredentialRegistration? {
        PassageAutofillAuthorizationController.shared.cancel()
        let rpId = response.handshake.challenge.publicKey.rp.id
        let challenge = response.handshake.challenge.publicKey.challenge
        let userId = response.user.id
        guard let decodedChallenge = challenge.decodeBase64Url() else {
            return nil
        }
        
        let platformCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(
            relyingPartyIdentifier: rpId
        )
        let platformRegistrationRequest = platformCredentialProvider
            .createCredentialRegistrationRequest(
                challenge: decodedChallenge,
                name: identifier,
                userID: Data(userId.utf8)
            )
        var requests: [ASAuthorizationRequest] = [platformRegistrationRequest]
        
        if includeSecurityKeyOption {
            let securityKeyCredentialProvider = ASAuthorizationSecurityKeyPublicKeyCredentialProvider(
                relyingPartyIdentifier: rpId
            )
            let securityKeyRegistrationRequest = securityKeyCredentialProvider
                .createCredentialRegistrationRequest(
                    challenge: decodedChallenge,
                    displayName: identifier,
                    name: identifier,
                    userID: Data(userId.utf8)
                )
            securityKeyRegistrationRequest.credentialParameters = [
                ASAuthorizationPublicKeyCredentialParameters(
                    algorithm: ASCOSEAlgorithmIdentifier.ES256
                )
            ]
            requests.append(securityKeyRegistrationRequest)
        }
        
        let authController = ASAuthorizationController(authorizationRequests: requests )
        authController.delegate = self
        authController.performRequests()
        
        return try await withCheckedThrowingContinuation(
            { [weak self] (continuation: CredentialRegistrationCheckedThrowingContinuation) in
                guard let self = self else {
                    return
                }
                self.credentialRegistrationCheckedThrowingContinuation = continuation
            }
        )

    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentialRegistration as ASAuthorizationPublicKeyCredentialRegistration:
            credentialRegistrationCheckedThrowingContinuation?.resume(returning: credentialRegistration)
            credentialRegistrationCheckedThrowingContinuation = nil
        default:
            credentialRegistrationCheckedThrowingContinuation?.resume(throwing: PassageASAuthorizationError.credentialRegistration)
        }
    }
    
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        // TODO: Implement better error handling below
        guard let authorizationError = error as? ASAuthorizationError else {
            credentialRegistrationCheckedThrowingContinuation?.resume(throwing: PassageASAuthorizationError.unknown)
            credentialRegistrationCheckedThrowingContinuation = nil
            return
        }


        if authorizationError.code == .canceled {
            // Either the system doesn't find any credentials and the request ends silently, or the user cancels the request.
            // This is a good time to show a traditional login form, or ask the user to create an account.
            credentialRegistrationCheckedThrowingContinuation?.resume(throwing: PassageASAuthorizationError.canceled)
            credentialRegistrationCheckedThrowingContinuation = nil
        } else {
            // Another ASAuthorization error.
            // Note: The userInfo dictionary contains useful information.
            credentialRegistrationCheckedThrowingContinuation?.resume(throwing: PassageASAuthorizationError.unknownAuthorizationType)
            credentialRegistrationCheckedThrowingContinuation = nil
        }
    }
    

    
}
