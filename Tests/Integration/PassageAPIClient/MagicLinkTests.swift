import XCTest
@testable import Passage

final class MagicLinkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        PassageSettings.shared.apiUrl = apiUrl
        PassageSettings.shared.appId = magicLinkAppId
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    @available(iOS 15.0, *)
    func testSendRegisterMagicLink() async {
        do {
            PassageAPIClient.shared.appId = magicLinkAppId
            let date = Date().timeIntervalSince1970
            let identifier = "authentigator+\(date)@passage.id"
            let response = try await PassageAPIClient.shared
                .sendRegisterMagicLink(identifier: identifier, path: nil, language: nil)
            do {
                _ = try await PassageAPIClient.shared.magicLinkStatus(id: response.id)
                XCTAssertTrue(false) // the status should error as it is unactivated
            } catch {
                XCTAssertTrue(true)
            }
        } catch {
            XCTAssertTrue(false)
        }
    }
    
    func testSendLoginMagicLink() async {
        do {
            PassageAPIClient.shared.appId = magicLinkAppId
            let response = try await PassageAPIClient.shared
                .sendLoginMagicLink(identifier: magicLinkRegisteredUserEmail, path: nil, language: nil)
            do {
                _ = try await PassageAPIClient.shared.magicLinkStatus(id: response.id)
                XCTAssertTrue(false) // the status should error as it is unactivated
            } catch {
                XCTAssertTrue(true)
            }
        } catch {
            print(error)
            XCTAssertTrue(false)
        }
    }
    
    func testActivateMagicLink() async {
        do {
            PassageAPIClient.shared.appId = magicLinkAppId
            let date = Date().timeIntervalSince1970
            let identifier = "authentigator+\(date)@\(MailosaurAPIClient.serverId).mailosaur.net"
            let response = try await PassageAPIClient.shared
                .sendRegisterMagicLink(identifier: identifier, path: nil, language: nil)
            try await Task.sleep(nanoseconds: checkEmailWaitTime)
            let magicLink = try await MailosaurAPIClient().getMostRecentMagicLink()
            let token = try await PassageAPIClient.shared.activateMagicLink(magicLink: magicLink)
            XCTAssertNotNil(token)
            do {
                _ = try await PassageAPIClient.shared.magicLinkStatus(id: response.id)
                XCTAssertTrue(true)
            } catch {
                XCTAssertTrue(false)
            }
        } catch {
            print(error)
            XCTAssertTrue(false)
        }
    }
}

