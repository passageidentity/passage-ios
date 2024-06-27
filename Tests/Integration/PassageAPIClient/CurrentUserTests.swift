import XCTest
@testable import Passage

final class CurrentUserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let passage = PassageAuth(appId: appInfoValid.id)
        passage.overrideApiUrl(with: apiUrl)
        // NOTE: These tests use static PassageAuth methods instead the passage instance.
        // * The passage instance utilizes keychain for token management, which is not supported in this kind of test environment.
        // * We still have to create this instance to override appId and ApiUrl (this will change in next major version).
    }

    
    func testCurrentUser() async {
        do {
            let user = try await PassageAuth.getCurrentUser(token: authToken)
            XCTAssertEqual(user.id, currentUser.id)
            XCTAssertEqual(user.createdAt, currentUser.createdAt)
            XCTAssertEqual(user.status, currentUser.status)
            XCTAssertEqual(user.email, currentUser.email)
            XCTAssertEqual(user.emailVerified, currentUser.emailVerified)
            XCTAssertEqual(user.phone, currentUser.phone)
            XCTAssertEqual(user.phoneVerified, currentUser.phoneVerified)
            XCTAssertEqual(user.webauthn, currentUser.webauthn)
            XCTAssertNil(user.userMetadata)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }

    func testCurrentUserNotAuthorized() async {
        do {
            let _ = try await PassageAuth.getCurrentUser(token: "")
            XCTFail("passage.getCurrentUser should throw an unauthorized error when no auth token set")
        } catch let error as UserError {
            XCTAssertEqual(error, .unauthorized)
        } catch {
            XCTFail("passage.getCurrentUser should throw an unauthorized error when no auth token set")
        }
    }

}
