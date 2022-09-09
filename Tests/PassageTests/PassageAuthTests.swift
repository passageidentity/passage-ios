import XCTest
@testable import Passage

final class PassageAuthTests: XCTestCase {
    func testHelloWorld() throws {
        XCTAssertEqual(PassageAuth.test(), "Hello world from Passage!")
    }
}
