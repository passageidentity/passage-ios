import XCTest
@testable import Passage

final class MagicLinkTests: XCTestCase {
    
    var passage: PassageAuth!
    
    override func setUp() {
        super.setUp()
        passage = PassageAuth(appId: magicLinkAppId)
        passage.overrideApiUrl(with: apiUrl)
    }
    
    @available(iOS 15.0, *)
    func testSendRegisterMagicLinkValid() async {
        do {
            let date = Date().timeIntervalSince1970
            let identifier = "authentigator+\(date)@passage.id"
            let _ = try await passage.newRegisterMagicLink(identifier: identifier)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testSendRegisterMagicLinkInvalid() async {
        do {
            let _ = try await passage.newRegisterMagicLink(identifier: "INVALID_IDENTIFIER")
            XCTFail("passage.newRegisterMagicLink should throw invalidIdentifier error when given an unactived magic link id")
        } catch let error as NewRegisterMagicLinkError {
            XCTAssertEqual(error, .invalidIdentifier)
        } catch {
            XCTFail("passage.newRegisterMagicLink should throw invalidIdentifier error when given an unactived magic link id")
        }
    }
    
    func testSendLoginMagicLinkValid() async {
        do {
            let _ = try await passage.newLoginMagicLink(identifier: magicLinkRegisteredUserEmail)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testSendLoginMagicLinkInvalid() async {
        do {
            let _ = try await passage.newLoginMagicLink(identifier: "INVALID_IDENTIFIER")
            XCTFail("passage.newLoginMagicLink should throw invalidIdentifier error when given an unactived magic link id")
        } catch let error as NewLoginMagicLinkError {
            XCTAssertEqual(error, .invalidIdentifier)
        } catch {
            XCTFail("passage.newLoginMagicLink should throw invalidIdentifier error when given an unactived magic link id")
        }
    }
    
    func testGetMagicLinkStatus() async {
        do {
            let _ = try await passage.getMagicLinkStatus(id: magicLinkUnactivatedId)
            XCTFail("passage.getMagicLinkStatus should throw magicLinkNotFound error when given an unactived magic link id")
        } catch let error as GetMagicLinkStatusError {
            XCTAssertEqual(error, .magicLinkNotFound)
        } catch {
            XCTFail("passage.getMagicLinkStatus should throw magicLinkNotFound error when given an unactived magic link id")
        }
    }

    func testActivateMagicLinkValid() async {
        do {
            let date = Date().timeIntervalSince1970
            let identifier = "authentigator+\(date)@\(MailosaurAPIClient.serverId).mailosaur.net"
            let response = try await passage.newRegisterMagicLink(identifier: identifier)
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
            // Should be able to exchange magic link for auth result
            let _ = try await passage.magicLinkActivate(userMagicLink: magicLink)
            // After activation, getMagicLinkStatus should return auth result, too.
            let _ = try await passage.getMagicLinkStatus(id: response.id)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testActivateMagicLinkInvalid() async {
        do {
            let _ = try await passage.magicLinkActivate(userMagicLink: "INVALID_MAGIC_LINK")
            XCTFail("passage.magicLinkActivate should throw magicLinkNotFound error when given an unactived magic link id")
        } catch let error as MagicLinkActivateError {
            XCTAssertEqual(error, .magicLinkNotFound)
        } catch {
            XCTFail("passage.magicLinkActivate should throw magicLinkNotFound error when given an unactived magic link id")
        }
    }

}
