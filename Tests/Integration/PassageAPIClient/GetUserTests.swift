import XCTest
@testable import Passage

final class GetUserTests: XCTestCase {

    func testUserFound() async {
        do {
            let passage = PassageAuth(appId: appInfoValid.id)
            passage.overrideApiUrl(with: apiUrl)
            let user = try await passage.getUser(identifier: registeredUserEmail)
            XCTAssertEqual(user?.id, currentUser.id)
            XCTAssertEqual(user?.status, currentUser.status)
            XCTAssertEqual(user?.email, currentUser.email)
            XCTAssertEqual(user?.emailVerified, currentUser.emailVerified)
            XCTAssertEqual(user?.phone, currentUser.phone)
            XCTAssertEqual(user?.phoneVerified, currentUser.phoneVerified)
            XCTAssertEqual(user?.webauthn, currentUser.webauthn)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
        
    }
    
    func testUserNotFound() async {
        let passage = PassageAuth(appId: appInfoValid.id)
        passage.overrideApiUrl(with: apiUrl)
        let user = try? await passage.getUser(identifier: unregisteredUserEmail)
        XCTAssertNil(user)
    }
    
}
