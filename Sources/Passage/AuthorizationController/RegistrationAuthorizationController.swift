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
class RegistrationAuthorizationController : NSObject, ASAuthorizationControllerDelegate {
    
    // registration continuations
    private typealias CredentialRegistrationCheckedThrowingContinuation = CheckedContinuation<ASAuthorizationPlatformPublicKeyCredentialRegistration, Error>
    private var credentialRegistrationCheckedThrowingContinuation: CredentialRegistrationCheckedThrowingContinuation? = nil

    
    
    static let shared = RegistrationAuthorizationController()
    
    public var domain: String
    
    private override init() {
        self.domain = PassageSettings.shared.authOrigin!
    }
    
    
    func register(from response: WebauthnRegisterStartResponse, identifier: String) async throws -> ASAuthorizationPlatformPublicKeyCredentialRegistration? {
        
        PassageAutofillAuthorizationController.shared.cancel()
        
        let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: domain)
        
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
    
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        let logger = Logger()
        switch authorization.credential {
        case let credentialRegistration as ASAuthorizationPlatformPublicKeyCredentialRegistration:
            logger.log("A new passkey was registered: \(credentialRegistration)")
            credentialRegistrationCheckedThrowingContinuation?.resume(returning: credentialRegistration)
            credentialRegistrationCheckedThrowingContinuation = nil
        default:
            credentialRegistrationCheckedThrowingContinuation?.resume(throwing: PassageASAuthorizationError.credentialRegistration)
        }
    }
    
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        credentialRegistrationCheckedThrowingContinuation?.resume(throwing: error)
//        credentialRegistrationCheckedThrowingContinuation = nil
        
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
