import Foundation
import os
import AuthenticationServices

@available(iOS 16.0, *)
class LoginAuthorizationController : NSObject, ASAuthorizationControllerDelegate, LoginAuthorizationControllerProtocol {

    private typealias CredentialAssertionCheckedThrowingContinuation =
        CheckedContinuation<ASAuthorizationPublicKeyCredentialAssertion, Error>
    private var credentialAssertionThrowingContinuation: CredentialAssertionCheckedThrowingContinuation? = nil

    static var shared: LoginAuthorizationControllerProtocol = LoginAuthorizationController()
    
    func login(from response: LoginWebAuthnStartResponse) async throws -> ASAuthorizationPublicKeyCredentialAssertion? {
        PassageAutofillAuthorizationController.shared.cancel()
        let challenge = response.handshake.challenge.publicKey.challenge
        guard
            let rpId = response.handshake.challenge.publicKey.rpId,
            let decodedChallenge = challenge.decodeBase64Url()
        else {
            return nil
        }
        // Handle platform request
        let platformCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(
            relyingPartyIdentifier: rpId
        )
        let platformAssertionRequest = platformCredentialProvider
            .createCredentialAssertionRequest(challenge: decodedChallenge)
        let platformCredentialIds = response.handshake.challenge.publicKey.allowCredentials?
            .compactMap { $0.id.decodeBase64Url() }
            .map { ASAuthorizationPlatformPublicKeyCredentialDescriptor(
                credentialID: $0
            ) }
        if let platformCredentialIds, !platformCredentialIds.isEmpty {
            platformAssertionRequest.allowedCredentials = platformCredentialIds
        }
        // Handle security key request
        let securityKeyCredentialProvider = ASAuthorizationSecurityKeyPublicKeyCredentialProvider(
            relyingPartyIdentifier: rpId
        )
        let securityKeyAssertionRequest = securityKeyCredentialProvider
            .createCredentialAssertionRequest(
                challenge: decodedChallenge
            )
        let securityKeyCredentialIds = response.handshake.challenge.publicKey.allowCredentials?
            .map {
                ASAuthorizationSecurityKeyPublicKeyCredentialDescriptor(
                    credentialID: $0.id.decodeBase64Url() ?? Data(),
                    transports:
                        $0.transports?.map {
                            ASAuthorizationSecurityKeyPublicKeyCredentialDescriptor.Transport($0)
                        } ?? []
                )
            }
        if let securityKeyCredentialIds, !securityKeyCredentialIds.isEmpty {
            securityKeyAssertionRequest.allowedCredentials = securityKeyCredentialIds
        }
        
        // Allow user to log in with platform passkey or security key:
        let requests = [
            platformAssertionRequest,
            securityKeyAssertionRequest
        ]
        let authController = ASAuthorizationController(authorizationRequests: requests)
        authController.delegate = self
        authController.performRequests()

        return try await withCheckedThrowingContinuation(
            { [weak self] (continuation: CredentialAssertionCheckedThrowingContinuation) in
                guard let self = self else {
                    return
                }
                self.credentialAssertionThrowingContinuation = continuation
            }
        )

    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentialAssertion as ASAuthorizationPublicKeyCredentialAssertion:
            credentialAssertionThrowingContinuation?.resume(returning: credentialAssertion)
            credentialAssertionThrowingContinuation = nil
        default:
            credentialAssertionThrowingContinuation?.resume(throwing: ASAuthorizationError.init(.invalidResponse))
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        credentialAssertionThrowingContinuation?.resume(throwing: error)
        credentialAssertionThrowingContinuation = nil
    }
    
}
