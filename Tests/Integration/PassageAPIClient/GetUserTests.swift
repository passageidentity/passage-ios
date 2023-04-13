import XCTest
@testable import Passage

final class GetUserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        PassageSettings.shared.apiUrl = apiUrl
        PassageSettings.shared.appId = appInfoValid.id
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testUserFound() async {
        do {
            PassageAPIClient.shared.appId = appInfoValid.id
            let response = try await PassageAPIClient.shared.getUser(identifier: registeredUser.email)
            XCTAssertEqual(response.id, currentUser.id)
            XCTAssertEqual(response.status, currentUser.status)
            XCTAssertEqual(response.email, currentUser.email)
            XCTAssertEqual(response.emailVerified, currentUser.emailVerified)
            XCTAssertEqual(response.phone, currentUser.phone)
            XCTAssertEqual(response.phoneVerified, currentUser.phoneVerified)
            XCTAssertEqual(response.webauthn, currentUser.webauthn)
        } catch {
            XCTAssertTrue(false)
        }
    }
    
    func testUserNotFound() async {
        do {
            PassageAPIClient.shared.appId = appInfoValid.id
            let _ = try await PassageAPIClient.shared.getUser(identifier: unregisteredUserEmail)
            XCTAssertFalse(true)
        }
        catch  {
            XCTAssertTrue(true)
        }
    }
    
}
