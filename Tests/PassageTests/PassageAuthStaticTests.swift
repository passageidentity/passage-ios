import XCTest
@testable import Passage

final class PassageAuthStaticTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        PassageSettings.shared.appId = testAppInfo.id
        PassageSettings.shared.authOrigin = testAppInfo.auth_origin
        PassageSettings.shared.apiUrl = "TEST_API_URL"
        PassageAPIClient.shared = MockPassageAPIClient()
        if #available(iOS 16.0, *) {
            LoginAuthorizationController.shared = MockLoginAuthorizationController()
            RegistrationAuthorizationController.shared = MockRegistrationAuthorizationController()
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPassageAuth_whenLoginNonexistingUser_throwsNotExistError() async {
        var thrownError: Error?
        do {
            let _ = try await PassageAuth.login(identifier: unregisteredUserEmail)
        } catch {
            thrownError = error
        }
        XCTAssertEqual(thrownError as? PassageError, .userDoesNotExist)
    }
    
    func testPassageAuth_whenRegisterExistingUser_throwsAlreadyExistsError() async {
        var thrownError: Error?
        do {
            let _ = try await PassageAuth.register(identifier: registeredUserEmail)
        } catch {
            thrownError = error
        }
        XCTAssertEqual(thrownError as? PassageError, .userAlreadyExists)
    }
    
    func testPassageAuth_whenLoginExistingUser_returnsValidAuthResult() async {
        let result = try? await PassageAuth.login(identifier: registeredUserEmail)
        if #available(iOS 16.0, *) {
            XCTAssertTrue(result?.authResult is AuthResult)
        } else {
            XCTAssertTrue(result?.magicLink is MagicLink)
        }
    }
    
    func testPassageAuth_whenRegisterNewUser_returnsValidAuthResult() async {
        let result = try? await PassageAuth.register(identifier: unregisteredUserEmail)
        if #available(iOS 16.0, *) {
            XCTAssertTrue(result?.authResult is AuthResult)
        } else {
            XCTAssertTrue(result?.magicLink is MagicLink)
        }
    }
    
    func testPassageAuth_whenGetExistingUser_returnsUser() async {
        let user = try? await PassageAuth.getUser(identifier: registeredUserEmail)
        XCTAssertNotNil(user)
    }
    
    func testPassageAuth_whenGetNonexistingUser_throwsError() async {
        var thrownError: Error?
        do {
            let _ = try await PassageAuth.getUser(identifier: unregisteredUserEmail)
        } catch {
            thrownError = error
        }
        XCTAssertEqual(thrownError as? PassageError, .userDoesNotExist)
    }
    
}
