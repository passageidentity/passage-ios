import XCTest
@testable import Passage

final class ChangeContactTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        PassageSettings.shared.apiUrl = apiUrl
        PassageSettings.shared.appId = appInfoValid.id
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testChangeEmail() async {
        // make sure we have an authToken.
        XCTAssertNotEqual(authToken, "")
        do {
            PassageAPIClient.shared.appId = appInfoValid.id
            let response = try await PassageAPIClient.shared
                .changeEmail(token: authToken, newEmail: "blayne.bayer+2@passage.id", magicLinkPath: nil, redirectUrl: nil, language: nil)
            XCTAssertNotNil(response.id)
        } catch {
            XCTAssertTrue(false)
        }
    }
    
    func testChangeEmailUnAuthed() async {
        do {
            PassageAPIClient.shared.appId = appInfoValid.id
            let response = try await PassageAPIClient.shared
                .changeEmail(token: "", newEmail: "blayne.bayer+2@passage.id", magicLinkPath: nil, redirectUrl: nil, language: nil)
            XCTAssertTrue(false)
        } catch {
            XCTAssertTrue(error is PassageAPIError)
            if let thrownError = error as? PassageAPIError {
                switch thrownError {
                    case .unauthorized:
                        XCTAssertTrue(true)
                default:
                    XCTAssertFalse(true)
                }
            }
        }
    }

    func testChangePhone() async {
        // make sure we have an authToken.
        XCTAssertNotEqual(authToken, "")
        do {
            PassageAPIClient.shared.appId = appInfoValid.id
            let response = try await PassageAPIClient.shared
                .changePhone(token: authToken, newPhone: "+15125874725", magicLinkPath: nil, redirectUrl: nil, language: nil)
            XCTAssertNotNil(response.id)
        } catch {
            XCTAssertTrue(false)
        }
    }

    func testChangePhoneInvalid() async {
        // make sure we have an authToken.
        XCTAssertNotEqual(authToken, "")
        do {
            PassageAPIClient.shared.appId = appInfoValid.id
            let response = try await PassageAPIClient.shared
                .changePhone(token: authToken, newPhone: "5125874725", magicLinkPath: nil, redirectUrl: nil, language: nil)
            XCTAssertTrue(false)
        } catch {
            XCTAssertTrue(error is PassageAPIError)
            if let thrownError = error as? PassageAPIError {
                switch thrownError {
                    case .badRequest:
                        XCTAssertTrue(true)
                default:
                    XCTAssertFalse(true)
                }
            }
        }
    }

    
    func testChangePhoneUnAuthed() async {
        do {
            PassageAPIClient.shared.appId = appInfoValid.id
            let response = try await PassageAPIClient.shared
                .changePhone(token: "", newPhone: "555-555-5555", magicLinkPath: nil, redirectUrl: nil, language: nil)
            XCTAssertTrue(false)
        } catch {
            XCTAssertTrue(error is PassageAPIError)
            if let thrownError = error as? PassageAPIError {
                switch thrownError {
                    case .unauthorized:
                        XCTAssertTrue(true)
                default:
                    XCTAssertFalse(true)
                }
            }
        }
    }
    
}
