import XCTest
@testable import Passage

final class CurrentUserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        PassageSettings.shared.apiUrl = apiUrl
        PassageSettings.shared.appId = appInfoValid.id
    }
    
    override func tearDown() {
        super.tearDown()
    }

    
    func testCurrentUser() async {
        // make sure we have an authToken.
        XCTAssertNotEqual(authToken, "")
        do {
            PassageAPIClient.shared.appId = appInfoValid.id
            let response = try await PassageAPIClient.shared.currentUser(token: authToken)
            XCTAssertEqual(response.id, currentUser.id)
            XCTAssertEqual(response.createdAt, currentUser.createdAt)
            XCTAssertEqual(response.status, currentUser.status)
            XCTAssertEqual(response.email, currentUser.email)
            XCTAssertEqual(response.emailVerified, currentUser.emailVerified)
            XCTAssertEqual(response.phone, currentUser.phone)
            XCTAssertEqual(response.phoneVerified, currentUser.phoneVerified)
            XCTAssertEqual(response.webauthn, currentUser.webauthn)
            XCTAssertNil(response.userMetadata)
        } catch {
            // fail the test if we catch an error
            XCTAssertTrue(false)
        }
    }

    func testCurrentUserNotAuthorized() async {
        do {
            PassageAPIClient.shared.appId = appInfoValid.id
            let _ = try await PassageAPIClient.shared.currentUser(token: "")
            // fail if we didn't get an error
            XCTAssertTrue(false)
        }
        catch {
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
