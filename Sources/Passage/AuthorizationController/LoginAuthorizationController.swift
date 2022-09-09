//
//  PassageAuthAsyncAuthorizationController.swift
//  Shiny
//
//  Created by blayne bayer on 8/24/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import os
import AuthenticationServices

@available(iOS 16.0, *)
class LoginAuthorizationController : NSObject, ASAuthorizationControllerDelegate {

    private typealias CredentialAssertionCheckedThrowingContinuation =
        CheckedContinuation<ASAuthorizationPlatformPublicKeyCredentialAssertion, Error>
    private var credentialAssertionThrowingContinuation: CredentialAssertionCheckedThrowingContinuation? = nil

    
    static let shared = LoginAuthorizationController()
    
    public var domain: String
    
    private override init() {
        self.domain = PassageSettings.shared.authOrigin!
    }
    
    
    func loginWithIdentifier(from response: WebauthnLoginStartResponse, identifier: String) async throws -> ASAuthorizationPlatformPublicKeyCredentialAssertion {
        PassageAutofillAuthorizationController.shared.cancel()
        let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: domain)
        let challenge = response.handshake.challenge.publicKey.challenge
        let decodedChallenge = challenge.decodeBase64Url()
        let assertionRequest = publicKeyCredentialProvider.createCredentialAssertionRequest(challenge: decodedChallenge!)
        let authController = ASAuthorizationController(authorizationRequests: [ assertionRequest ] )
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
    
    func login(from response: WebauthnLoginStartResponse) async throws -> ASAuthorizationPlatformPublicKeyCredentialAssertion {
        PassageAutofillAuthorizationController.shared.cancel()
        let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: domain)
        let challenge = response.handshake.challenge.publicKey.challenge
        let decodedChallenge = challenge.decodeBase64Url()
        let assertionRequest = publicKeyCredentialProvider.createCredentialAssertionRequest(challenge: decodedChallenge!)
        let authController = ASAuthorizationController(authorizationRequests: [ assertionRequest ] )
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
        let logger = Logger()
        switch authorization.credential {
        case let credentialAssertion as ASAuthorizationPlatformPublicKeyCredentialAssertion:
            logger.log("A  passkey was used to sign in: \(credentialAssertion)")
            credentialAssertionThrowingContinuation?.resume(returning: credentialAssertion)
            credentialAssertionThrowingContinuation = nil
        default:
            credentialAssertionThrowingContinuation?.resume(throwing: PassageASAuthorizationError.unknownAuthorizationType)
        }
    }
    
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        // TODO: Implement better error handling below
        guard let authorizationError = error as? ASAuthorizationError else {
            credentialAssertionThrowingContinuation?.resume(throwing: PassageASAuthorizationError.unknown)
            credentialAssertionThrowingContinuation = nil
            return
        }


        if authorizationError.code == .canceled {
            // Either the system doesn't find any credentials and the request ends silently, or the user cancels the request.
            // This is a good time to show a traditional login form, or ask the user to create an account.
            credentialAssertionThrowingContinuation?.resume(throwing: PassageASAuthorizationError.canceled)
            credentialAssertionThrowingContinuation = nil
        } else {
            // Another ASAuthorization error.
            // Note: The userInfo dictionary contains useful information.
            credentialAssertionThrowingContinuation?.resume(throwing: PassageASAuthorizationError.unknownAuthorizationType)
            credentialAssertionThrowingContinuation = nil
        }
    }
    

    
}
