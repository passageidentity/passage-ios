import XCTest
@testable import Passage

final class OneTimePasscodeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        PassageSettings.shared.apiUrl = apiUrl
        PassageSettings.shared.appId = otpAppInfoValid.id
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    @available(iOS 15.0, *)
    func testSendRegisterOneTimePasscode() async {
        do {
            PassageAPIClient.shared.appId = otpAppInfoValid.id
            let date = Date().timeIntervalSince1970
            let identifier = "authentigator+\(date)@passage.id"
            let _ = try await PassageAPIClient.shared
                .sendRegisterOneTimePasscode(identifier: identifier, language: nil)
            XCTAssertTrue(true)
        } catch {
            XCTAssertTrue(false)
        }
    }
    
    func testSendLoginOneTimePasscode() async {
        do {
            PassageAPIClient.shared.appId = otpAppInfoValid.id
            let _ = try await PassageAPIClient.shared
                .sendLoginOneTimePasscode(identifier: otpRegisteredUser.email ?? "", language: nil)
            XCTAssertTrue(true)
        } catch {
            XCTAssertTrue(false)
        }
    }

    func testActivateOneTimePasscode() async {
        do {
            PassageAPIClient.shared.appId = otpAppInfoValid.id
            let date = Date().timeIntervalSince1970
            let identifier = "authentigator+\(date)@\(MailosaurAPIClient.serverId).mailosaur.net"
            let response = try await PassageAPIClient.shared
                .sendRegisterOneTimePasscode(identifier: identifier, language: nil)
            
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
            let token = try await PassageAPIClient.shared.activateOneTimePasscode(otp: oneTimePasscode, otpId: response.id)
            XCTAssertNotNil(token)
        } catch {
            print(error)
            XCTAssertTrue(false)
        }
    }

}
