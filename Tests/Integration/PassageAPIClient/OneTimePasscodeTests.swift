import XCTest
@testable import Passage

final class OneTimePasscodeTests: XCTestCase {
    
    var passage: PassageAuth!
    
    override func setUp() {
        super.setUp()
        passage = PassageAuth(appId: otpAppId)
        passage.overrideApiUrl(with: apiUrl)
    }
    
    func testSendRegisterOneTimePasscodeValid() async {
        do {
            let date = Date().timeIntervalSince1970
            let identifier = "authentigator+\(date)@passage.id"
            let _ = try await passage.newRegisterOneTimePasscode(identifier: identifier)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testSendRegisterOneTimePasscodeInvalid() async {
        do {
            let _ = try await passage.newRegisterOneTimePasscode(identifier: "INVALID_IDENTIFIER")
            XCTFail("passage.newRegisterOneTimePasscode should throw invalidIdentifier error when given an unactived magic link id")
        } catch let error as NewRegisterOneTimePasscodeError {
            XCTAssertEqual(error, .invalidIdentifier)
        } catch {
            XCTFail("passage.newRegisterOneTimePasscode should throw invalidIdentifier error when given an unactived magic link id")
        }
    }
    
    func testSendLoginOneTimePasscodeValid() async {
        do {
            let _ = try await passage.newLoginOneTimePasscode(identifier: otpRegisteredEmail)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testSendLoginOneTimePasscodeInvalid() async {
        do {
            let _ = try await passage.newLoginOneTimePasscode(identifier: "INVALID_IDENTIFIER")
            XCTFail("passage.newLoginOneTimePasscode should throw invalidIdentifier error when given an unactived magic link id")
        } catch let error as NewLoginOneTimePasscodeError {
            XCTAssertEqual(error, .invalidIdentifier)
        } catch {
            XCTFail("passage.newLoginOneTimePasscode should throw invalidIdentifier error when given an unactived magic link id")
        }
    }

    func testActivateOneTimePasscode() async {
        do {
            let date = Date().timeIntervalSince1970
            let identifier = "authentigator+\(date)@\(MailosaurAPIClient.serverId).mailosaur.net"
            let otp = try await passage.newRegisterOneTimePasscode(identifier: identifier)
            
            var oneTimePasscode: String? = nil
            let mailosaurApiClient = MailosaurAPIClient()
            for _ in 1...checkEmailTryCount {
                try? await Task.sleep(nanoseconds: checkEmailWaitTime)
                oneTimePasscode = await mailosaurApiClient.getMostRecentOneTimePasscode()
                if oneTimePasscode != nil {
                    break
                }
            }
            XCTAssertNotNil(oneTimePasscode)
            guard let oneTimePasscode else { return }
            let _ = try await passage.oneTimePasscodeActivate(otp: oneTimePasscode, otpId: otp.id)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }

}
