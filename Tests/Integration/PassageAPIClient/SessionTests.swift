import XCTest
@testable import Passage

final class SessionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        PassageSettings.shared.apiUrl = apiUrl
        PassageSettings.shared.appId = appInfoRefreshToken.id
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRefreshAndSignOut() async {
        do{
            // Sign in and get tokens
            PassageAPIClient.shared.appId = appInfoRefreshToken.id
            let date = Date().timeIntervalSince1970
            let identifier = "authentigator+\(date)@\(MailosaurAPIClient.serverId).mailosaur.net"
            _ = try await PassageAPIClient.shared
                .sendRegisterMagicLink(identifier: identifier, path: nil, language: nil)
            try await Task.sleep(nanoseconds: UInt64(3 * Double(NSEC_PER_SEC)))
            let magicLink = try await MailosaurAPIClient().getMostRecentMagicLink()
            let tokens = try await PassageAPIClient.shared.activateMagicLink(magicLink: magicLink)
            XCTAssertNotNil(tokens.refreshToken)
            
            // Refresh the tokens
            let newTokens = try? await PassageAPIClient.shared.refresh(refreshToken: tokens.refreshToken ?? "")
            XCTAssertNotNil(newTokens?.authToken)
            XCTAssertNotNil(newTokens?.refreshToken)
            XCTAssertFalse(newTokens?.refreshToken == tokens.refreshToken)
            
            // Sign out the session
            try await PassageAPIClient.shared.signOut(refreshToken: newTokens?.refreshToken ?? "")
            let nanoseconds = Double(appInfoRefreshToken.sessionTimeoutLength) * Double(NSEC_PER_SEC)
            try await Task.sleep(nanoseconds: UInt64(nanoseconds))
            do {
                _ = try await PassageAPIClient.shared.currentUser(token: newTokens?.authToken ?? "")
                XCTAssertTrue(false) // the above function should throw an unauthenticated exception
            } catch {
                XCTAssertTrue(error is PassageAPIError)
                
                if let thrownError = error as? PassageAPIError {
                    switch thrownError {
                        case .unauthorized( _ ):
                            XCTAssertTrue(true)
                    default:
                        XCTAssertFalse(true)
                    }
                }
            }

        } catch {
            print(error)
            XCTAssertTrue(false)
        }
    }
}
