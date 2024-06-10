import XCTest
@testable import Passage

final class SessionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let passage = PassageAuth(appId: refreshTestAppId)
        passage.overrideApiUrl(with: apiUrl)
        // NOTE: These tests use static PassageAuth methods instead the passage instance.
        // * The passage instance utilizes keychain for token management, which is not supported in this kind of test environment.
        // * We still have to create this instance to override appId and ApiUrl (this will change in next major version).
    }
    
    func testRefreshAndSignOut() async {
        do{
            // Sign in and get tokens
            let date = Date().timeIntervalSince1970
            let identifier = "authentigator+\(date)@\(MailosaurAPIClient.serverId).mailosaur.net"
            let _ = try await PassageAuth.newRegisterMagicLink(identifier: identifier)
            var magicLink: String? = nil
            let mailosaurApiClient = MailosaurAPIClient()
            for _ in 1...checkEmailTryCount {
                try? await Task.sleep(nanoseconds: checkEmailWaitTime)
                magicLink = await mailosaurApiClient.getMostRecentMagicLink()
                if magicLink != nil {
                    break
                }
            }
            XCTAssertNotNil(magicLink)
            guard let magicLink else { return }
            let authResult = try await PassageAuth.magicLinkActivate(userMagicLink: magicLink)
            XCTAssertNotNil(authResult.refreshToken)
            
            // Refresh the tokens
            let newAuthResult = try? await PassageAuth.refresh(refreshToken: authResult.refreshToken ?? "")
            XCTAssertNotNil(newAuthResult)
            XCTAssertNotNil(newAuthResult?.authToken)
            XCTAssertNotNil(newAuthResult?.refreshToken)
            XCTAssertFalse(newAuthResult?.refreshToken == authResult.refreshToken)
            
            // Sign out the session
            try await PassageAuth.signOut(refreshToken: newAuthResult?.refreshToken ?? "")
            let nanoseconds = Double(refreshTestSessionTimeout) * Double(NSEC_PER_SEC)
            try await Task.sleep(nanoseconds: UInt64(nanoseconds))
            do {
                _ = try await PassageAuth.getCurrentUser(token: newAuthResult?.authToken ?? "")
                XCTFail("getCurrentUser should throw an unauthenticated error")
            } catch {
                // TODO: catch specific error
            }
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
}
