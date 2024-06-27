import Foundation
import AuthenticationServices
import os

@available(iOS 16.0, *)
public class PassageAutofillAuthorizationController : NSObject, ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    public static let shared = PassageAutofillAuthorizationController()
    
    var authController : ASAuthorizationController?
    var startResponse : LoginWebAuthnStartResponse?
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
        let startResponse = try await PassageAuth.autoFillStart()
        self.startResponse = startResponse
        
        guard let rpId = startResponse.handshake.challenge.publicKey.rpId else { return }
        let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: rpId)
        
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
                guard startResponse != nil else {
                    throw ASAuthorizationError.init(.invalidResponse)
                }
                let loginResult = try await PassageAuth.autoFillFinish(startResponse: startResponse!, credentialAssertion: credentialAssertion)
                isPerformingModalRequest = false
                if let onSuccess {
                    onSuccess(loginResult)
                }
            }
        default:
            isPerformingModalRequest = false
            if let onError = onError {
                onError(ASAuthorizationError.init(.invalidResponse))
            }
        }
        isPerformingModalRequest = false
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

