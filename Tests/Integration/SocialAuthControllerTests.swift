import XCTest
@testable import Passage

final class SocialAuthControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        PassageSettings.shared.apiUrl = apiUrl
        PassageSettings.shared.appId = appInfoValid.id
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetSocialAuthQueryParams() async {
        let window = await UIWindow()
        let socialAuthController = PassageSocialAuthController(window: window)
        guard let appId = PassageSettings.shared.appId else {
            return XCTFail("App id not found")
        }
        
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
        XCTAssert(queryParams.contains("redirect_uri=\(appId)://"))
        XCTAssert(queryParams.contains("state="))
        XCTAssert(queryParams.contains("code_challenge="))
        XCTAssert(queryParams.contains("code_challenge_method=S256"))
        XCTAssert(queryParams.contains("connection_type=\(connection.rawValue)"))
    }
    
    func testGetAuthUrl() async {
        do {
            let window = await UIWindow()
            let socialAuthController = PassageSocialAuthController(window: window)
            let connection = PassageSocialConnection.github
            guard let appId = PassageSettings.shared.appId else {
                return XCTFail("App id not found")
            }
            guard let apiUrl = PassageSettings.shared.apiUrl else {
                return XCTFail("API URL not found")
            }
            let queryParams = socialAuthController.getSocialAuthQueryParams(
                appId: appId,
                connection: connection
            )
            let expectedAuthUrl = URL(string: "\(apiUrl)/v1/apps/\(appId)/social/authorize?\(queryParams)")
            let authUrl = try PassageAPIClient.shared.getAuthUrl(queryParams: queryParams)
            XCTAssertEqual(expectedAuthUrl, authUrl)
        } catch {
            XCTFail("Failed to get auth url.")
        }
    }
    
}
