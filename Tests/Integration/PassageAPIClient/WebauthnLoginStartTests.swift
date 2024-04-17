import XCTest
@testable import Passage

final class WebauthnLoginStartTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        PassageSettings.shared.apiUrl = apiUrl
        PassageSettings.shared.appId = appInfoValid.id
    }
    
    override func tearDown() {
        super.tearDown()
    }

    @available(iOS 16.0, *)
    func testWebauthnLoginStart() async {
        do {
            PassageAPIClient.shared.appId = appInfoValid.id
            let _ = try await PassageAPIClient.shared.webauthnLoginStart(identifier: nil, authenticatorAttachment: nil)
            // ensure we got a response. Pretty much all we can test for now.
            // If the response changes it should throw a swiftdecode error, which would fail the test
            XCTAssertTrue(true)
            
        } catch {
            debugPrint("getUser Exception:",error)
            XCTAssertTrue(false)
        }
    }
    
}
