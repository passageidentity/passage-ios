//
//  PassageAutoFillAuthorizationController.swift
//  Shiny
//
//  Created by blayne bayer on 8/22/22.
//  Copyright © 2022 Apple. All rights reserved.
//

import Foundation
import AuthenticationServices
import os

@available(iOS 16.0, *)
public class PassageAutofillAuthorizationController : NSObject, ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    public static let shared = PassageAutofillAuthorizationController()
    
    var authController : ASAuthorizationController?
    var startResponse : WebauthnLoginStartResponse?
    var isPerformingModalRequest : Bool = false
    var authenticationAnchor: ASPresentationAnchor?
    
    var onSuccess: ((AuthResult) -> Void)?
    var onError: ((Error) -> Void)?
    var onCancel: (() -> Void)?
    
    override private init () {

    }
    
    // MARK: Methods

    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return authenticationAnchor!
    }

    public func cancel() {
        if self.authController != nil  {
            
            self.authController!.delegate = nil
            self.authController!.presentationContextProvider = nil
            self.authController!.cancel()
            
            self.authController = nil
        }
    }
    
    public func begin(anchor: ASPresentationAnchor, onSuccess:  ((AuthResult) -> Void)?, onError: ((Error) -> Void)?, onCancel: (() -> Void)? ) async throws -> Void {
     
        self.onSuccess = onSuccess
        self.onError = onError
        self.onCancel = onCancel
        
        self.authenticationAnchor = anchor
        self.startResponse = try await PassageAuth.autoFillStart()
        
        let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: PassageSettings.shared.authOrigin!)
        
        let challenge = self.startResponse!.handshake.challenge.publicKey.challenge
        let decodedChallenge = challenge.decodeBase64Url()
        
        let assertionRequest = publicKeyCredentialProvider.createCredentialAssertionRequest(challenge: decodedChallenge!)

        self.authController = ASAuthorizationController(authorizationRequests: [ assertionRequest ] )
        self.authController!.delegate = self
        self.authController!.presentationContextProvider = self
        self.authController!.performAutoFillAssistedRequests()
        
    }
    
    // MARK: ASAuthorizationController
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentialAssertion as ASAuthorizationPlatformPublicKeyCredentialAssertion:
            Task {
                guard self.startResponse != nil else {
                    throw PassageASAuthorizationError.invalidStartResponse
                }
                let loginResult = try await PassageAuth.autoFillFinish(startResponse: self.startResponse!, credentialAssertion: credentialAssertion)
                if (loginResult.authToken != nil) {
                    self.isPerformingModalRequest = false
                    if let onSuccess = self.onSuccess {
                        onSuccess(loginResult)
                    }
                } else {
                    self.isPerformingModalRequest = false
                    if let onError = self.onError {
                        onError(PassageASAuthorizationError.loginFinish)
                    }

                }
            }
        default:
            self.isPerformingModalRequest = false
            if let onError = self.onError {
                onError(PassageASAuthorizationError.authorizationTypeUnknown)
            }
        }
        
        self.isPerformingModalRequest = false
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let logger = Logger()
        logger.log("authorizationController ERROR: \(error)")
        
        guard let authorizationError = error as? ASAuthorizationError else {
            self.isPerformingModalRequest = false
            logger.error("Unexpected authorization error: \(error.localizedDescription)")
            return
        }
        
        if authorizationError.code == .canceled {
            logger.log("Request canceled.")
            
            if self.isPerformingModalRequest {
                if let onCancel = self.onCancel {
                    onCancel()
                }
            }
        } else {
            logger.error("Error: \((error as NSError).userInfo)")
        }
        
        self.isPerformingModalRequest = false
    }
    
}

