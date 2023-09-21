import Foundation
import os
import AuthenticationServices

@available(iOS 16.0, *)
class RegistrationAuthorizationController : NSObject, ASAuthorizationControllerDelegate, RegistrationAuthorizationControllerProtocol {
    
    // registration continuations
    private typealias CredentialRegistrationCheckedThrowingContinuation = CheckedContinuation<ASAuthorizationPlatformPublicKeyCredentialRegistration, Error>
    private var credentialRegistrationCheckedThrowingContinuation: CredentialRegistrationCheckedThrowingContinuation? = nil

    private typealias CredentialRegistrationSecurityCheckedThrowingContinuation = CheckedContinuation<ASAuthorizationSecurityKeyPublicKeyCredentialRegistration, Error>
    private var credentialRegistrationSecurityCheckedThrowingContinuation: CredentialRegistrationSecurityCheckedThrowingContinuation? = nil
    
    
    static var shared: RegistrationAuthorizationControllerProtocol = RegistrationAuthorizationController()
    
    func register(from response: WebauthnRegisterStartResponse, identifier: String) async throws -> ASAuthorizationPlatformPublicKeyCredentialRegistration? {
        
        PassageAutofillAuthorizationController.shared.cancel()
        
        let rpId = response.handshake.challenge.publicKey.rp.id
        
        let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: rpId)
        
        let challenge = response.handshake.challenge.publicKey.challenge
        let userId = response.user.id
        
        let decodedChallenge = challenge.decodeBase64Url()
        
        let registrationRequest = publicKeyCredentialProvider.createCredentialRegistrationRequest(challenge: decodedChallenge!, name: identifier, userID: Data(userId.utf8))
        
        let authController = ASAuthorizationController(authorizationRequests: [ registrationRequest ] )
        authController.delegate = self
//        authController.presentationContextProvider = self
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
    
    func registerSecurityKey(from response: WebauthnRegisterStartResponse, identifier: String) async throws -> ASAuthorizationSecurityKeyPublicKeyCredentialRegistration? {
        
        PassageAutofillAuthorizationController.shared.cancel()
        
        let rpId = response.handshake.challenge.publicKey.rp.id
        
//        let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: rpId)
        let securityKeyCredentialProvider = ASAuthorizationSecurityKeyPublicKeyCredentialProvider(relyingPartyIdentifier: rpId)
        
        let challenge = response.handshake.challenge.publicKey.challenge
        let userId = response.user.id
        
        let decodedChallenge = challenge.decodeBase64Url()
        
//        let registrationRequest = publicKeyCredentialProvider.createCredentialRegistrationRequest(challenge: decodedChallenge!, name: identifier, userID: Data(userId.utf8))
        let registrationRequest = securityKeyCredentialProvider.createCredentialRegistrationRequest(challenge: decodedChallenge!, displayName: "User name", name: identifier, userID: Data(userId.utf8))
        registrationRequest.credentialParameters = [ ASAuthorizationPublicKeyCredentialParameters(algorithm: ASCOSEAlgorithmIdentifier.ES256) ]
        
        let authController = ASAuthorizationController(authorizationRequests: [ registrationRequest ] )
        authController.delegate = self
//        authController.presentationContextProvider = self
        authController.performRequests()
        
        return try await withCheckedThrowingContinuation(
            { [weak self] (continuation: CredentialRegistrationSecurityCheckedThrowingContinuation) in
                guard let self = self else {
                    return
                }
                self.credentialRegistrationSecurityCheckedThrowingContinuation = continuation
            }
        )

    }
    
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("didCompleteWithAuthorization")
        let logger = Logger()
        switch authorization.credential {
        case let credentialRegistration as ASAuthorizationPlatformPublicKeyCredentialRegistration:
            logger.log("A new passkey was registered: \(credentialRegistration)")
            credentialRegistrationCheckedThrowingContinuation?.resume(returning: credentialRegistration)
            credentialRegistrationCheckedThrowingContinuation = nil
        case let credentialRegistration as ASAuthorizationSecurityKeyPublicKeyCredentialRegistration:
            logger.log("A new passkey was registered: \(credentialRegistration)")
            credentialRegistrationSecurityCheckedThrowingContinuation?.resume(returning: credentialRegistration)
            credentialRegistrationSecurityCheckedThrowingContinuation = nil
        default:
            print("Got here`")
            credentialRegistrationCheckedThrowingContinuation?.resume(throwing: PassageASAuthorizationError.credentialRegistration)
        }
    }
    
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        credentialRegistrationCheckedThrowingContinuation?.resume(throwing: error)
//        credentialRegistrationCheckedThrowingContinuation = nil
        print("didCompleteWithError")
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
