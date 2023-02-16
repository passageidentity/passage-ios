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

    
    func testCurrentUser() async {
        
        // make sure we have an authToken.
        XCTAssertNotEqual(authToken, "")
        
        do {
            PassageAPIClient.shared.appId = appInfoValid.id
            let response = try await PassageAPIClient.shared.currentUser(token: authToken)
            XCTAssertEqual(response.id, currentUser.id)
            XCTAssertEqual(response.created_at, currentUser.created_at)
            XCTAssertEqual(response.updated_at, currentUser.updated_at)
            XCTAssertEqual(response.status, currentUser.status)
            XCTAssertEqual(response.email, currentUser.email)
            XCTAssertEqual(response.email_verified, currentUser.email_verified)
            XCTAssertEqual(response.phone, currentUser.phone)
            XCTAssertEqual(response.phone_verified, currentUser.phone_verified)
            XCTAssertEqual(response.webauthn, currentUser.webauthn)
        } catch {
            debugPrint("testCurrentUser: error:",error)
            // fail the test if we catch an error
            XCTAssertTrue(false)
        }
        
    }

    func testCurrentUserNotAuthorized() async {
        do {
            PassageAPIClient.shared.appId = appInfoValid.id
            let response = try await PassageAPIClient.shared.currentUser(token: "")
            // fail if we didn't get an error
            XCTAssertTrue(false)
        }
        catch {
            XCTAssertTrue(error is PassageAPIError)
            
            if let thrownError = error as? PassageAPIError {
                switch thrownError {
                    case .unauthorized(let response):
                        XCTAssertTrue(true)
                default:
                    XCTAssertFalse(true)
                }
            }
        }
    }

}
