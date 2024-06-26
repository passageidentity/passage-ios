import XCTest
@testable import Passage

final class AppInfoTests: XCTestCase {
    
    func testAppInfoFound() async {
        do {
            let passage = PassageAuth(appId: appInfoValid.id)
            passage.overrideApiUrl(with: apiUrl)
            let appInfo = try await passage.appInfo()
            XCTAssertTrue(appInfo.id == appInfoValid.id)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }

    func testAppInfoNotFound() async {
        do {
            let passage = PassageAuth(appId: "INVALID_ID")
            passage.overrideApiUrl(with: apiUrl)
            let _ = try await passage.appInfo()
            XCTFail("passage.appInfo should have thrown an appNotFound error.")
        } catch let error as AppInfoError {
            XCTAssertEqual(error, .appNotFound)
        } catch {
            XCTFail("passage.appInfo should have thrown an appNotFound error.")
        }
    }

}
