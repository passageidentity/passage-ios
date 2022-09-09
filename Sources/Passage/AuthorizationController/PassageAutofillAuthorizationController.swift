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
class PassageAutofillAuthorizationController : NSObject, PassageAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    static let shared = PassageAutofillAuthorizationController()
    
    var authController : ASAuthorizationController?
    var autofillDelegate : PassageAuthorizationControllerDelegate?
    var startResponse : WebauthnLoginStartResponse?
    var isPerformingModalRequest : Bool = false
    var authenticationAnchor: ASPresentationAnchor?
    
    
    override private init () {

    }
    
    
    // MARK: PassageAuthorizationControllerDelegate methods
    func success() {
        let logger = Logger()
        logger.log("Autofill Success")
    }
    
    func error(error: Error) {
        let logger = Logger()
        logger.log("Autofill Error \(error)")
    }
    
    func didCancelModalSheet() {
        let logger = Logger()
        logger.log("Did cancel modal sheet")
    }
    
    
    // MARK: Methods

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return authenticationAnchor!
    }

    func cancel() {
        if self.authController != nil  {
            
            self.authController!.delegate = nil
            self.authController!.presentationContextProvider = nil
            self.authController!.cancel()
            
            self.authController = nil
        }
    }
    
    func begin(anchor: ASPresentationAnchor) async throws -> Void {
     
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
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        let logger = Logger()
        
        logger.log("Running PassagePasskeyAutofill controller didCompleteWithAuthorization")
        
        switch authorization.credential {
        case let credentialAssertion as ASAuthorizationPlatformPublicKeyCredentialAssertion:
            logger.log("A passkey was used to sign in.")
            Task {
                guard self.startResponse != nil else {
                    throw PassageASAuthorizationError.invalidStartResponse
                }
                let loginResult = try await PassageAuth.autoFillFinish(startResponse: self.startResponse!, credentialAssertion: credentialAssertion)
                if (loginResult.auth_token != nil) {
                    print("****************")
                    print("Login success")
                    print(loginResult.auth_token ?? "Failed")
                    print("****************")
                    self.isPerformingModalRequest = false
                    self.autofillDelegate!.success()
                } else {
                    print("****************")
                    print("Login Failed")
                    print("error:")
//                    print(loginResult.error)
                    print("****************")
                    self.isPerformingModalRequest = false
                    self.autofillDelegate!.error(error: PassageASAuthorizationError.loginFinish)
                }
            }
        default:
            logger.log("Received unknown authorization type")
            self.isPerformingModalRequest = false
            self.autofillDelegate!.error(error: PassageASAuthorizationError.authorizationTypeUnknown)
        }
        
        self.isPerformingModalRequest = false
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
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
                self.autofillDelegate!.didCancelModalSheet()
            }
        } else {
            logger.error("Error: \((error as NSError).userInfo)")
        }
        
        self.isPerformingModalRequest = false
    }
    
}

