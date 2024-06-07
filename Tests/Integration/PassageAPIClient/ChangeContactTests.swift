import XCTest
@testable import Passage

final class ChangeContactTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let passage = PassageAuth(appId: appInfoValid.id)
        passage.overrideApiUrl(with: apiUrl)
        // NOTE: These tests use static PassageAuth methods instead the passage instance.
        // * The passage instance utilizes keychain for token management, which is not supported in this kind of test environment.
        // * We still have to create this instance to override appId and ApiUrl (this will change in next major version).
    }
    
    func testChangeEmail() async {
        do {
            let _ = try await PassageAuth.changeEmail(token: authToken, newEmail: "ricky.padilla+user02@passage.id")
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testChangeEmailUnAuthed() async {
        do {
            let _ = try await PassageAuth.changeEmail(token: "", newEmail: "ricky.padilla+user02@passage.id")
            XCTFail("passage.changeEmail should throw an error when no auth token set")
        } catch {
            // TODO: catch specific error
        }
    }

    func testChangePhone() async {
        do {
            try? await Task.sleep(nanoseconds: checkEmailWaitTime)
            let _ = try await PassageAuth.changePhone(token: authToken, newPhone: "+15125874725")
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }

    func testChangePhoneInvalid() async {
        do {
            let _ = try await PassageAuth.changePhone(token: authToken, newPhone: "5125874725")
            XCTFail("passage.changePhone should throw an error when invalid phone is sent")
        } catch {
            // TODO: catch specific error
        }
    }

    
    func testChangePhoneUnAuthed() async {
        do {
            let _ = try await PassageAuth.changePhone(token: "", newPhone: "+15125874725")
            XCTFail("passage.changePhone should throw an error when no auth token set")
        } catch {
            // TODO: catch specific error
        }
    }
    
}
