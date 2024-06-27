import XCTest
@testable import Passage

final class SocialAuthControllerTests: XCTestCase {
    
    var passage: PassageAuth!
    
    override func setUp() {
        super.setUp()
        passage = PassageAuth(appId: appInfoValid.id)
        passage.overrideApiUrl(with: apiUrl)
    }
    
    func testGetSocialAuthQueryParams() async {
        let window = await UIWindow()
        let socialAuthController = PassageSocialAuthController(window: window)
        let appId = appInfoValid.id
        
        // Verifier should be an empty string before calling getSocialAuthQueryParams
        XCTAssert(socialAuthController.verifier.isEmpty)
        
        // Get query parameters for GitHub Social Auth
        let connection = PassageSocialConnection.github
        let queryParams = socialAuthController.getSocialAuthQueryParams(
            appId: appId,
            connection: connection
        )
        
        // Verifier should NOT be an empty string after calling getSocialAuthQueryParams
        XCTAssert(!socialAuthController.verifier.isEmpty)
        
        // Query params should contain the following strings:
        XCTAssert(queryParams.contains("redirect_uri=passage-\(appId)://"))
        XCTAssert(queryParams.contains("state="))
        XCTAssert(queryParams.contains("code_challenge="))
        XCTAssert(queryParams.contains("code_challenge_method=S256"))
        XCTAssert(queryParams.contains("connection_type=\(connection.rawValue)"))
    }
    
    func testGetAuthUrl() async {
        let window = await UIWindow()
        let socialAuthController = PassageSocialAuthController(window: window)
        let connection = PassageSocialConnection.github
        let appId = appInfoValid.id
        let queryParams = socialAuthController.getSocialAuthQueryParams(
            appId: appId,
            connection: connection
        )
        let expectedAuthUrl = URL(string: "\(apiUrl)/apps/\(appId)/social/authorize?\(queryParams)")
        let authUrl = PassageAuth.getSocialAuthUrl(queryParams: queryParams)
        XCTAssertNotNil(authUrl)
        XCTAssertEqual(expectedAuthUrl, authUrl)
    }
    
    func testAppleAuthorizationFailure() async {
        do {
            // SIWA has not been configured for this iOS app, so iOS will throw an authorization error.
            let window = await UIWindow()
            let _ = try await passage.authorize(with: .apple, in: window)
            XCTFail("passage.appInfo should throw an authorizationFailed error.")
        } catch let error as SocialAuthError {
            XCTAssertEqual(error, .authorizationFailed)
        } catch {
            XCTFail("passage.appInfo should throw an authorizationFailed error.")
        }
    }
    
}
