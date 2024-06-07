import XCTest
@testable import Passage

final class SocialAuthControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let passage = PassageAuth(appId: appInfoValid.id)
        passage.overrideApiUrl(with: apiUrl)
        // NOTE: These tests use static PassageAuth methods instead the passage instance.
        // * The passage instance utilizes keychain for token management, which is not supported in this kind of test environment.
        // * We still have to create this instance to override appId and ApiUrl (this will change in next major version).
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
    
}
