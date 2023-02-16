//
//  File.swift
//
//
//  Created by blayne bayer on 2/15/23.
//

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

    
    func testCurrentUSer() {
        // make sure we have an authToken.
        XCTAssertNotEqual(authToken, "")
    }
//    func testUserFound() async {
//        do {
//            PassageAPIClient.shared.appId = appInfoValid.id
//            let response = try await PassageAPIClient.shared.getUser(identifier: registeredUser.email ?? "")
//            XCTAssertEqual(response, registeredUser)
//            
//        } catch {
//            XCTAssertTrue(false)
//        }
//    }
//    
//    func testUserNotFound() async {
//        do {
//            PassageAPIClient.shared.appId = appInfoValid.id
//            let response = try await PassageAPIClient.shared.getUser(identifier: unregisteredUserEmail)
//            XCTAssertFalse(true)
//        }
//        catch  {
//            XCTAssertTrue(true)
//        }
//        
//    }
}
